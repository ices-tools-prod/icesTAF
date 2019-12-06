#' @rdname icesTAF-internal
#'
#' @importFrom tools file_path_as_absolute
#'
#' @export

## Helper function for process.bib

process.inner <- function(bib, dir, quiet)
{
  key <- attr(bib, "key")

  ## Case 1: R package on GitHub
  if(grepl("@", bib$source[1]))
  {
    targz <- download.github(bib$source, "software", quiet=quiet)
    taf.install(file.path("software",targz), lib="library", quiet=quiet)
  }

  ## Case 2: File to download
  else if(grepl("^http", bib$source[1]))
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
    ## Shorthand notation: source = {file} means key is a filename
    if(bib$source[1] == "file")
      bib$source[1] <- file.path("initial", dir, key)
    sapply(bib$source, cp, to=dir)
  }
}
