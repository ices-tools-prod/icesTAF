#' Bootstrap TAF Analysis
#'
#' Set up data files and software required for the analysis. Model configuration
#' files are also set up, if found.
#'
#' @param clean whether to \code{\link{clean}} directories during the bootstrap
#'        procedure.
#' @param config whether to process configuration files.
#' @param data whether to process data.
#' @param software whether to process software.
#' @param quiet whether to suppress messages reporting progress.
#'
#' @note
#' This function should be called from the top directory of a TAF analysis. It
#' looks for a directory called \file{bootstrap} and prepares data files and
#' software according to metadata specifications.
#'
#' The bootstrap procedure consists of the following steps:
#' \enumerate{
#' \item If a directory \verb{bootstrap/initial/config} contains model
#'       configuration files, they are copied to \verb{bootstrap/config}.
#' \item If a \verb{bootstrap/DATA.bib} metadata file exists, it is processed
#'       with \code{\link{process.bib}}.
#' \item If a \verb{bootstrap/SOFTWARE.bib} metadata file exists, it is
#'       processed with \code{\link{process.bib}}.
#' }
#'
#' After the bootstrap procedure, data and software have been documented and
#' are ready to be used in the subsequent analysis. Specifically, the procedure
#' populates up to four new directories:
#' \itemize{
#' \item \verb{bootstrap/config} with model configuration files.
#' \item \verb{bootstrap/data} with data files.
#' \item \verb{bootstrap/library} with R packages compiled for the local
#'       platform.
#' \item \verb{bootstrap/software} with software files, such as R packages in
#'       \verb{tar.gz} source code format.
#' }
#'
#' @seealso
#' \code{\link{process.bib}} is a helper function used to process metadata.
#'
#' \code{\link{taf.library}} loads a package from \verb{bootstrap/library}.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' taf.bootstrap()
#' }
#'
#' @export

taf.bootstrap <- function(clean=TRUE, config=TRUE, data=TRUE, software=TRUE,
                          quiet=FALSE)
{
  if(clean)
    clean()

  if(!dir.exists("bootstrap"))
    return(invisible(NULL))  # nothing to do
  if(!quiet)
    msg("Bootstrap procedure running...")

  ## Work inside bootstrap
  setwd("bootstrap"); on.exit(setwd(".."))

  ## 1  Process config
  if(config && dir.exists("initial/config"))
  {
    if(!quiet)
      message("Processing config")
    if(clean)
      clean("config")
    cp("initial/config", ".")
  }

  ## 2  Process data
  if(data)
  {
    if(!quiet)
      message("Processing DATA.bib")
    if(clean)
      clean("data")
    process.bib("DATA.bib", quiet=quiet)
  }

  ## 3  Process software
  if(software)
  {
    if(!quiet)
      message("Processing SOFTWARE.bib")
    if(clean)
      clean(c("library", "software"))
    process.bib("SOFTWARE.bib", quiet=quiet)
  }

  ## Remove empty folders
  rmdir(c("config", "data", "library", "software"))
  rmdir("library:", recursive=TRUE)  # this directory name can appear in Linux

  if(!quiet)
    msg("Bootstrap procedure done")

  invisible(NULL)
}
