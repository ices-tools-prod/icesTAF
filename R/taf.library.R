#' Enable TAF Library
#'
#' Add local TAF library \file{bootstrap/library} to the search path, where
#' packages are stored.
#'
#' @param names whether to return the names of packages currently installed in
#'        the TAF library.
#'
#' @return
#' The resulting search path, or names of packages if \code{names = TRUE}.
#'
#' @note
#' This function inserts the entry \code{"bootstrap/library"} in front of the
#' existing library search path.
#'
#' The purpose of the TAF library is to retain R packages used in a TAF
#' assessment that are not archived on CRAN, to support long-term
#' reproducibility of TAF assessments.
#'
#' @seealso
#' \code{\link{taf.install}} installs a package from GitHub into the TAF
#' library.
#'
#' \code{\link{.libPaths}} is the underlying base function to set the library
#' search path.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' taf.library()
#' library(this)
#' library(that)
#'
#' # Show packages in TAF library
#' taf.library(TRUE)
#' }
#'
#' @importFrom utils installed.packages
#'
#' @export

taf.library <- function(names=FALSE)
{
  .libPaths(unique(c("bootstrap/library", .libPaths())))
  if(names)
    unname(installed.packages(lib.loc="bootstrap/library")[,"Package"])
}
