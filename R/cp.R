#' Copy Files
#'
#' Copy files, overwriting existing files if necessary, and returning the result
#' invisibly.
#'
#' @param from source file names. Multiple filenames can be matched using
#'        wildcard notation, such as \code{*.csv} to copy all CSV files.
#' @param to destination file names, or directory.
#'
#' @return
#' \code{TRUE} for success, \code{FALSE} for failure, invisibly.
#'
#' @note
#' Shorthand for \code{invisible(file.copy(..., overwrite = TRUE))}.
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
  invisible(file.copy(Sys.glob(from), to, overwrite=TRUE))
}
