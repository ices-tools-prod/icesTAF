#' Bootstrap TAF Analysis
#'
#' Process metadata files \file{DATA.bib} and \file{SOFTWARE.bib} to set up data
#' files and  software required for the analysis.
#'
#' @param data whether to process \verb{DATA.bib}.
#' @param software whether to process \verb{SOFTWARE.bib}.
#' @param clean whether to \code{\link{clean}} directories during the bootstrap
#'        procedure.
#' @param force whether to process \verb{DATA.bib} and \verb{SOFTWARE.bib}
#'        unconditionally.
#' @param quiet whether to suppress messages reporting progress.
#' @param \dots passed to \code{\link{make}}, e.g. \code{debug = TRUE}.
#'
#' @details
#' The default \code{clean = TRUE} cleans (1) \verb{bootstrap/data} if
#' \verb{DATA.bib} is processed, (2) \verb{bootstrap/library} and
#' \verb{bootstrap/software} if \verb{SOFTWARE.bib} is processed, and (3) top
#' directories \verb{data}, \verb{model}, \verb{output}, and \verb{report} if
#' either \verb{DATA.bib} or \verb{SOFTWARE.bib} is processed.
#'
#' The default \code{force = FALSE} only processes \verb{DATA.bib} when it is
#' newer than the \verb{bootstrap/data} directory, and \verb{SOFTWARE.bib} when
#' it is newer than the \verb{bootstrap/software} directory.
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

taf.bootstrap <- function(data=TRUE, software=TRUE,
                          clean=TRUE, force=FALSE, quiet=FALSE, ...)
{
  if(!dir.exists("bootstrap"))
    return(invisible(NULL))  # nothing to do
  if(!quiet)
    msg("Bootstrap procedure running...")

  ## Work inside bootstrap
  setwd("bootstrap"); on.exit(setwd(".."))

  out <- c(DATA.bib=FALSE, SOFTWARE.bib=FALSE)

  ## 1  Process data
  if(data && file.exists("DATA.bib"))
  {
    out["DATA.bib"] <-
      make("DATA.bib", NULL, "data", engine=process.bib,
           clean=clean, force=force, quiet=quiet, ...)
    if(out["DATA.bib"])
      clean(c("../data", "../model", "../output", "../report"))
  }

  ## 2  Process software
  if(software && file.exists("SOFTWARE.bib"))
  {
    out["SOFTWARE.bib"] <-
      make("SOFTWARE.bib", NULL, "software", engine=process.bib,
           clean=clean, force=force, quiet=quiet, ...)
    if(out["SOFTWARE.bib"])
      clean(c("../data", "../model", "../output", "../report"))
  }

  ## Remove empty folders
  rmdir(c("data", "library", "software"), recursive=TRUE)
  rmdir("library:", recursive=TRUE)  # this directory name can appear in Linux

  if(!quiet)
    msg("Bootstrap procedure done")

  invisible(out)
}
