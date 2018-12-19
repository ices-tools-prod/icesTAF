#' Bootstrap TAF Analysis
#'
#' Set up data files and software required for the analysis. Model configuration
#' files are also set up, if found.
#'
#' @note
#' This function should be called from the top directory of a TAF analysis. It
#' looks for a directory called \file{bootstrap} containing metadata and
#' possibly other files.
#'
#' The bootstrap procedure consists of the following steps:
#' \enumerate{
#' \item If a directory \file{bootstrap/initial/config} contains model
#' configuration files, they are copied to \file{bootstrap/config}.
#' \item If a directory \file{bootstrap/initial/config} contains model
#' configuration files, they are copied to \file{bootstrap/config}.
#' }
#'
#' @seealso
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' taf.bootstrap()
#' }
#'
#' @importFrom remotes install_github parse_repo_spec
#' @importFrom bibtex read.bib
#'
#' @export

taf.bootstrap <- function()
{
  if(!dir.exists("bootstrap"))
    stop("'bootstrap' directory not found")

  ## 1  Create empty subdirectories
  taf.library(quiet=TRUE)
  setwd("bootstrap"); on.exit(setwd(".."))
  mkdir(c("config", "data", "library", "software"))

  ## 2a  Process config
  if(dir.exists("initial/config"))
    cp("initial/config", ".")

  ## 2b  Process data
  datasets <- if(file.exists("DATA.bib")) read.bib("DATA.bib") else list()
  for(dat in datasets)
  {
    if(grepl("^http", dat$source))
    {
      download(dat$source, dir="data")
    }
    else
    {
      if(dat$source == "file")
        dat$source <- file.path("initial/data", attr(dat,"key"))
      cp(dat$source, "data")
    }
  }

  ## 2c  Process software
  software <- if(file.exists("SOFTWARE.bib")) read.bib("SOFTWARE.bib")
              else list()
  for(soft in software)
  {
    if(grepl("@", soft$source))
    {
      spec <- parse_repo_spec(soft$source)
      url <- paste0("https://api.github.com/repos/",
                    spec$username, "/", spec$repo, "/tarball/", spec$ref)
      targz <- paste0(spec$repo, "_", spec$ref, ".tar.gz")
      suppressWarnings(download(url, destfile=file.path("software", targz)))
      install_github(soft$source, upgrade=FALSE, force=TRUE)
    }
    else if(grepl("^http", soft$source))
    {
      download(soft$source, dir="software")
    }
    else
    {
      if(dat$source == "file")
        dat$source <- file.path("initial/software", attr(dat,"key"))
      cp(soft$source, "software")
    }
  }

  ## 3  Remove empty folders
  rmdir(c("config", "data", "library", "software"))
  rmdir("library:", recursive=TRUE)  # this directory name can appear in Linux

  invisible(NULL)
}
