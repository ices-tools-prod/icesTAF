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
#' Specifically, this function sets \code{"boot/library"} as the first element
#' of \code{.libPaths()}. This is rarely beneficial in TAF scripts, but can be
#' useful when using the \pkg{sessioninfo} package, for example.
#'
#' @section Warning:
#' An unwanted side effect of having the TAF library as the first element in the
#' search path is that \code{install.packages} will then install packages inside
#' \verb{boot/library}. This is not a serious side effect, since a subsequent
#' call to \code{taf.boot} or  \code{clean.library} will remove packages from
#' the TAF library that are not declared in the \file{SOFTWARE.bib} file.
#'
#' @seealso
#' \code{\link{.libPaths}} is the underlying function to modify the search path
#' for R packages.
#'
#' \code{\link{taf.library}} loads a package from \verb{boot/library}.
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
  if(is.null(boot.dir()))
  {
    warning("'boot' folder does not exist")
    return(.libPaths())
  }

  if(remove)
  {
    include <- .libPaths() != file.path(getwd(), boot.dir(), "library")
    .libPaths(.libPaths()[include])
  }
  else  # add
  {
    bootlib <- file.path(boot.dir(), "library")
    if(!dir.exists(bootlib))
      warning("'", bootlib, "' does not exist")
    .libPaths(c(bootlib, .libPaths()))
  }
  .libPaths()
}
