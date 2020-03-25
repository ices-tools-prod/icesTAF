#' Add TAF Library Path
#'
#' Add TAF library to the search path for R packages.
#'
#' @return The resulting vector of file paths.
#'
#' @note
#' Specifically, this function sets \code{"bootstrap/library"} as the first
#' element of \code{.libPaths()}. This is rarely beneficial in TAF scripts, but
#' can be useful when using the \pkg{sessioninfo} package, for example.
#'
#' @seealso
#' \code{\link{.libPaths}} is the underlying function to modify the search path
#' for R packages.
#'
#' \code{\link{taf.library}} loads a package from \verb{bootstrap/library}.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \donttest{
#' taf.libPaths()
#' }
#'
#' @importFrom utils file_test
#'
#' @export

taf.libPaths <- function()
{
  ## dir.exists() requires R 3.2, so we use older file_test
  if(!file_test("-d", "bootstrap/library"))
    warning("'bootstrap/library' does not exist")
  .libPaths(c("bootstrap/library", .libPaths()))
}
