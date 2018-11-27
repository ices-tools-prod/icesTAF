#' Create Directory
#'
#' Create directory, including parent directories if necessary, without
#' generating a warning if the directory already exists.
#'
#' @param path a directory name.
#'
#' @return \code{TRUE} for success, \code{FALSE} for failure, invisibly.
#'
#' @seealso
#' \code{\link{dir.create}} is the base function to create a new directory.
#'
#' \code{\link{rmdir}} removes an empty directory.
#'
#' \code{\link{clean}} can be used to remove non-empty directories.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' mkdir("emptydir")
#' rmdir("emptydir")
#'
#' mkdir("outer/inner")
#' rmdir("outer", recursive=TRUE)
#' }
#'
#' @export

mkdir <- function(path)
{
  out <- sapply(path, dir.create, showWarnings=FALSE, recursive=TRUE)
  invisible(out)
}
