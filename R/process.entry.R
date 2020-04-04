#' @rdname icesTAF-internal
#'
#' @importFrom tools file_path_as_absolute
#'
#' @export

## Process bib entry

process.entry <- function(bib, dir, quiet)
{
  key <- attr(bib, "key")

  ## Case 1: Resource on GitHub
  if(grepl("@", bib$source[1]))
  {
    targz <- download.github(bib$source, dir, quiet=quiet)
    if(dir == "software")
    {
      spec <- parse.repo(bib$source[1])
      ## is.r.package was already called in download.github, so don't warn again
      if(is.r.package(file.path("software",targz), spec=spec, warn=FALSE))
        taf.install(file.path("software",targz), lib="library", quiet=quiet)
    }
  }

  ## Case 2: File to download
  else if(grepl("^http://", bib$source[1]) ||
          grepl("^https://", bib$source[1]) ||
          grepl("^ftp://", bib$source[1]))
  {
    sapply(bib$source, download, dir=dir, quiet=quiet)
  }

  ## Case 3: R script in bootstrap directory
  else if(bib$source[1] == "script")
  {
    script <- file_path_as_absolute(paste0(key, ".R"))
    owd <- setwd(dir); on.exit(setwd(owd))
    source(script)
  }

  ## Case 4: File to copy
  else
  {
    ## Warn if entry looks like GitHub without a @reference
    if(grepl("/", bib$source) &&               # source entry includes /
       sub("/.*","",bib$source)!="initial" &&  # but does not start with initial
       !grepl("@", bib$source))                # and does not include @
      warning("'", key,
              "' entry might be a GitHub reference that is missing the '@'")
    ## Shorthand notation: source = {file} means key is a filename
    if(bib$source[1] %in% c("file","folder"))
      bib$source[1] <- file.path("initial", dir, key)
    sapply(bib$source, cp, to=dir)
  }
}
