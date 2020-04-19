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
    destfile <- basename(bib$source)
    destfile <- gsub("\\?.*", "", destfile)   # file.dat?tail -> file.dat
    destfile <- gsub(" |%20", "_", destfile)  # my%20script.R -> my_script.R
    for(i in seq_along(bib$source))
    {
      if(!file.exists(file.path(dir, destfile[i])))
        download(bib$source[i], dir=dir, quiet=quiet)
      else if(!quiet)
        message("  Skipping download of '", destfile[i],
                "' (already in place).")
    }
  }

  ## Case 3: R script in bootstrap directory
  else if(bib$source[1] == "script")
  {
    script <- file_path_as_absolute(paste0(key, ".R"))
    owd <- setwd(dir); on.exit(setwd(owd))
    if(length(dir(recursive=TRUE)) == 0)  # no destination files exist yet
      source(script)
    else if(!quiet)
      message("  Skipping script '", basename(script), "' (already in place).")
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
