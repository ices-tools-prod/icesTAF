#' Copy File
#'
#' Copy file, overwriting existing file if necessary, and returning the result
#' invisibly.
#'
#' @param from source file name.
#' @param to destination file name.
#'
#' @return
#' \code{TRUE} for success, \code{FALSE} for failure, invisibly.
#'
#' @note
#' Shorthand for \code{invisible(file.copy(..., overwrite=TRUE))}.
#'
#' @seealso
#' \code{\link{file.copy}} is the base function to copy files.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' write(pi, "A.txt")
#' cp("A.txt", "B.txt")
#' file.remove("A.txt", "B.txt")
#' }
#'
#' @export

cp <- function(from, to)
{
  invisible(file.copy(from, to, overwrite=TRUE))
}
