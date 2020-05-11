#' Add TAF Library Path
#'
#' Add TAF library to the search path for R packages.
#'
#' @param remove whether to remove TAF library from the search path, instead of
#'        adding it.
#'
#' @return The resulting vector of file paths.
#'
#' @note
#' Specifically, this function sets \code{"bootstrap/library"} as the first
#' element of \code{.libPaths()}. This is rarely beneficial in TAF scripts, but
#' can be useful when using the \pkg{sessioninfo} package, for example.
#'
#' @section Warning:
#' An unwanted side effect of having the TAF library as the first element in the
#' search path is that \code{install.packages} will then install packages inside
#' \verb{bootstrap/library}. This is not a serious side effect, since a
#' subsequent call to \code{taf.bootstrap} or  \code{clean.library} will remove
#' packages from the TAF library that are not declared in the
#' \file{SOFTWARE.bib} file.
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
#' taf.libPaths(remove=TRUE)
#' }
#'
#' @export

taf.libPaths <- function(remove=FALSE)
{
  if(remove)
  {
    include <- .libPaths() != file.path(getwd(), "bootstrap/library")
    .libPaths(.libPaths()[include])
  }
  else
  {
    if(!dir.exists("bootstrap/library"))
      warning("'bootstrap/library' does not exist")
    .libPaths(c("bootstrap/library", .libPaths()))
  }
  .libPaths()
}
