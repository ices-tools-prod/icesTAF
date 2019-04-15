#' TAF Library
#'
#' Load package from local TAF library.
#'
#' @param package name of a package found in \verb{bootstrap/library}.
#' @param messages whether to show messages when package loads.
#' @param warnings whether to show warnings when package loads.
#'
#' @return The names of packages currently installed in the TAF library.
#'
#' @note
#' The purpose of the TAF library is to retain R packages that are not commonly
#' used (and not on CRAN), to support long-term reproducibility of TAF analyses.
#'
#' @seealso
#' \code{\link{library}} is the underlying base function to load a package.
#'
#' \code{\link{taf.bootstrap}} is the procedure to install packages into a local
#' TAF library, via the \file{SOFTWARE.bib} metadata file.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#'
#' # Show packages in TAF library
#' taf.library()
#'
#' # Load packages
#' taf.library(this)
#' taf.library(that)
#' }
#'
#' @importFrom utils installed.packages
#'
#' @export

taf.library <- function(package, messages=FALSE, warnings=FALSE)
{
  if(!dir.exists("bootstrap/library"))
    stop("directory 'bootstrap/library' not found")

  installed <- unname(rownames(installed.packages("bootstrap/library")))
  if(missing(package))
    return(installed)

  package <- as.character(substitute(package))
  if(!(package %in% installed))
    stop("there is no package '", package, "' in bootstrap/library")

  supM <- if(messages) identity else suppressMessages
  supW <- if(warnings) identity else suppressWarnings
  supW(supM(library(package, lib.loc="bootstrap/library", character.only=TRUE)))
}
