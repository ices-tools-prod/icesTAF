#' @rdname icesTAF-internal
#'
#' @importFrom tools file_path_as_absolute
#'
#' @export

## Process bib entry

process.entry <- function(bib, quiet = FALSE, force = FALSE, clean = FALSE) {
  owd <- setwd("bootstrap")
  on.exit(setwd(owd))

  if (inherits(bib, "bibentry")) {
    bib <- unclass(bib)[[1]]
  }

  key <- attr(bib, "key")
  if (!quiet) {
    msg("* ", key)
  }

  ## If source contains multiple files then split into vector
  bib$source <- trimws(unlist(strsplit(bib$source, "\\n")))
  bib$source <- sub(",$", "", bib$source) # remove trailing comma
  bib$source <- bib$source[bib$source != ""] # remove empty strings

  ## Check if access matches allowed values
  access <- bib$access
  if (!is.null(access)) {
    ## icesTAF:::access.vocab is a string vector of allowed 'access' values
    if (!is.character(access) || !(access %in% access.vocab)) {
      stop(
        "'access' values must be \"",
        paste(access.vocab, collapse = "\", \""), "\""
      )
    }
  }

  ## Add prefix
  bib$source <- paste0(bib$prefix, bib$source)

  ## Prepare dir, where bib$dir starts as: TRUE, FALSE, string, or NULL
  bib$dir <- as.logical(bib$dir) # is now TRUE, FALSE, NA, or logical(0)
  if (identical(bib$dir, NA)) {
    stop("parsing entry '", key, "' - dir should be TRUE or unspecified")
  }
  dir <- bib$type
  if (isTRUE(bib$dir) ||
    length(bib$source) > 1 ||
    bib$source[1] == "script") {
    dir <- file.path(dir, key)
  }
  mkdir(dir) # target directory

  ## Case 1: Resource on GitHub
  if (grepl("@", bib$source[1])) {
    targz <- download.github(bib$source, dir, quiet = quiet)
    if (dir == "software") {
      spec <- parse.repo(bib$source[1])
      ## is.r.package was already called in download.github, so don't warn again
      if (is.r.package(file.path("software", targz), spec = spec, warn = FALSE)) {
        taf.install(file.path("software", targz), lib = "library", quiet = quiet)
      }
    }
  }

  ## Case 2: File to download
  else if (grepl("^http://", bib$source[1]) ||
    grepl("^https://", bib$source[1]) ||
    grepl("^ftp://", bib$source[1])) {
    destfile <- basename(bib$source)
    destfile <- gsub("\\?.*", "", destfile) # file.dat?tail -> file.dat
    destfile <- gsub(" |%20", "_", destfile) # my%20script.R -> my_script.R
    for (i in seq_along(bib$source))
    {
      if (!file.exists(file.path(dir, destfile[i])) || isTRUE(force)) {
        download(bib$source[i], dir = dir, quiet = quiet)
      }
      else if (!quiet) {
        message(
          "  Skipping download of '", destfile[i],
          "' (already in place)."
        )
      }
    }
  }

  ## Case 3: R script in bootstrap directory
  else if (bib$source[1] == "script") {
    script <- tools::file_path_as_absolute(paste0(key, ".R"))
    if (clean) {
      unlink(dir, recursive = TRUE)
      mkdir(dir)
    }
    setwd(dir)
    if (length(dir(recursive = TRUE)) == 0 || isTRUE(force)) {
      # no destination files exist yet, or force == TRUE
      source(script)
    }
    else if (!quiet) {
      message(
        "  Skipping script '", basename(script),
        "' (directory contains files already)."
      )
    }
  }

  ## Case 4: File to copy
  else {
    ## Warn if entry looks like GitHub without a @reference
    if (grepl("/", bib$source) && # source entry includes /
      sub("/.*", "", bib$source) != "initial" && # but does not start with initial
      !grepl("@", bib$source)) { # and does not include @
      warning(
        "'", key,
        "' entry might be a GitHub reference that is missing the '@'"
      )
    }
    ## Shorthand notation: source = {file} means key is a filename
    if (bib$source[1] %in% c("file", "folder")) {
      bib$source[1] <- file.path("initial", dir, key)
    }
    sapply(bib$source, cp, to = dir)
  }

  invisible(TRUE)
}