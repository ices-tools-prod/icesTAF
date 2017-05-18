#' Make Directory
#'
#' Create directory, including parent directories if necessary, without
#' generating a warning if the directory already exists.
#'
#' @param path a directory name.
#'
#' @return
#' \code{TRUE} for success, \code{FALSE} for failure, invisibly.
#'
#' @note
#' Shorthand for \code{dir.create(path, showWarnings=FALSE, recursive=TRUE)}.
#'
#' @seealso
#' \code{\link{dir.create}} is the base function to create an empty directory.
#'
#' \code{\link{rmdir}} and \code{\link{unlink}} remove directories.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' mkdir("emptydir")
#' rmdir("emptydir")
#'
#' mkdir("outer/inner")
#' rmdir("outer/inner", recursive=TRUE)
#' }
#'
#' @export

mkdir <- function(path)
{
  dir.create(path, showWarnings=FALSE, recursive=TRUE)
}
