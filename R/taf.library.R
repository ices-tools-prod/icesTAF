#' Enable TAF Library
#'
#' Add local TAF library \file{bootstrap/library} to the search path, where
#' packages are stored.
#'
#' @return
#' The names of packages currently installed in the TAF library.
#'
#' @note
#' This function inserts the directory entry \code{"bootstrap/library"} in front
#' of the existing library search path. The directory is created, if it does not
#' already exist.
#'
#' The purpose of the TAF library is to retain R packages used in a TAF
#' analysis that are not archived on CRAN, to support long-term
#' reproducibility of TAF analyses.
#'
#' @seealso
#' \code{\link{taf.install}} installs a package from GitHub into the TAF
#' library.
#'
#' \code{\link{.libPaths}} is the underlying base function to get/set the
#' library search path.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#'
#' # Enable TAF library
#' taf.library()
#'
#' # Show updated path
#' .libPaths()
#'
#' # Load packages
#' library(this)
#' library(that)
#'
#' # BibTeX references
#' library(bibtex)
#' write.bib(taf.library())
#' }
#'
#' @importFrom utils installed.packages
#'
#' @export

taf.library <- function()
{
  if(!dir.exists("bootstrap/library"))
  {
    mkdir("bootstrap/library")
    message("Created empty dir 'bootstrap/library'.")
  }
  .libPaths(unique(c("bootstrap/library", .libPaths())))
  pkgs <- unname(installed.packages(lib.loc="bootstrap/library")[,"Package"])
  if(length(pkgs) == 0)
    return(invisible(pkgs))
  else
    pkgs
}
