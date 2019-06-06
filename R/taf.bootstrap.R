#' Bootstrap TAF Analysis
#'
#' Set up data files and software required for the analysis.
#'
#' @param clean whether to \code{\link{clean}} directories during the bootstrap
#'        procedure.
#' @param data whether to process data files.
#' @param software whether to process software.
#' @param quiet whether to suppress messages reporting progress.
#'
#' @return Logical vector indicating which metadata files were processed.
#'
#' @note
#' This function should be called from the top directory of a TAF analysis. It
#' looks for a directory called \file{bootstrap} and prepares data files and
#' software according to metadata specifications.
#'
#' The bootstrap procedure consists of the following steps:
#' \enumerate{
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
#' \item \verb{bootstrap/data} with data files.
#' \item \verb{bootstrap/library} with R packages compiled for the local
#'       platform.
#' \item \verb{bootstrap/software} with software files, such as R packages in
#'       \verb{tar.gz} source code format.
#' }
#'
#' Model settings and configuration files can be set up within
#' \verb{SOFTWARE.bib}, see \code{\link{process.bib}}.
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

taf.bootstrap <- function(clean=TRUE, data=TRUE, software=TRUE, quiet=FALSE)
{
  if(clean)
    clean()

  if(!dir.exists("bootstrap"))
    return(invisible(NULL))  # nothing to do
  if(!quiet)
    msg("Bootstrap procedure running...")

  ## Work inside bootstrap
  setwd("bootstrap"); on.exit(setwd(".."))

  out <- c(DATA.bib=FALSE, SOFTWARE.bib=FALSE)

  ## 1  Process data
  if(data && file.exists("DATA.bib"))
    out["DATA.bib"] <- process.bib("DATA.bib", clean=clean, quiet=quiet)

  ## 2  Process software
  if(software && file.exists("SOFTWARE.bib"))
    out["SOFTWARE.bib"] <- process.bib("SOFTWARE.bib", clean=clean, quiet=quiet)

  ## Remove empty folders
  rmdir(c("data", "library", "software"), recursive=TRUE)
  rmdir("library:", recursive=TRUE)  # this directory name can appear in Linux

  if(!quiet)
    msg("Bootstrap procedure done")

  invisible(out)
}
