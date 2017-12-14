#' Copy Files
#'
#' Copy files, overwriting existing files if necessary, and returning the result
#' invisibly.
#'
#' @param from source filenames, e.g. \code{*.csv}.
#' @param to destination filenames, or directory.
#' @param move whether to move instead of copy.
#'
#' @return \code{TRUE} for success, \code{FALSE} for failure, invisibly.
#'
#' @note Shorthand for \code{invisible(file.copy(..., overwrite = TRUE))}.
#'
#' @seealso
#' \code{\link{file.copy}} and \code{\link{file.rename}} are the base functions
#' to copy and move files.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' write(pi, "A.txt")
#' cp("A.txt", "B.txt")
#' cp("A.txt", "B.txt", move=TRUE)
#' file.remove("B.txt")
#' }
#'
#' @export

cp <- function(from, to, move=FALSE)
{
  ## Include both glob matches and filenames without asterisk,
  ## in case some filenames without asterisk are not found
  from <- sort(unique(c(Sys.glob(from), from[!grepl("\\*", from)])))

  ret <- file.copy(from, to, overwrite=TRUE)
  if(move)
    ret <- file.remove(from)
  names(ret) <- from

  invisible(ret)
}
