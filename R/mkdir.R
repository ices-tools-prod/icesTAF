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
#' \code{\link{dir.create}} is the base function to create an empty directory.
#'
#' \code{\link{unlink}} with \code{recursive = TRUE} removes directories.
#'
#' \code{\link{clean}} cleans TAF directories.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' mkdir("emptydir")
#' unlink("emptydir", recursive=TRUE)
#'
#' mkdir("outer/inner")
#' unlink("outer/inner", recursive=TRUE)
#' }
#'
#' @export

mkdir <- function(path)
{
  out <- sapply(path, dir.create, showWarnings=FALSE, recursive=TRUE)
  invisible(out)
}
