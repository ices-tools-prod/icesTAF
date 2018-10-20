#' TAF Library
#'
#' Add TAF library to the search path where packages are stored.
#'
#' @return
#' A vector of file paths.
#'
#' @note
#' This function inserts the entry \code{"bootstrap/library"} in front of
#' the existing library search path.
#'
#' @seealso
#' \code{\link{.libPaths}} gets/sets the library search path.
#'
#' \code{\link{library}} looks for packages to load from the library search
#'  path.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' .libPaths()
#' taflib()
#' .libPaths()
#'
#' @export

taflib <- function()
{
  .libPaths(unique(c("bootstrap/library", .libPaths())))
}
