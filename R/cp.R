#' Copy Files
#'
#' Copy or move files, overwriting existing files if necessary, and returning
#' the result invisibly.
#'
#' @param from source filenames, e.g. \code{*.csv}.
#' @param to destination filenames, or directory.
#' @param move whether to move instead of copy.
#'
#' @return \code{TRUE} for success, \code{FALSE} for failure, invisibly.
#'
#' @seealso
#' \code{\link{file.copy}} and \code{\link{unlink}} are the underlying functions
#' used to copy and (if \code{move = TRUE}) delete files.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' write(pi, "A.txt")
#' cp("A.txt", "B.txt")
#' cp("A.txt", "B.txt", move=TRUE)
#'
#' ## Copy directory tree
#' cp(system.file(package="datasets"), ".")
#' mkdir("everything")
#' cp("datasets/*", "everything")
#' }
#'
#' @export

cp <- function(from, to, move=FALSE)
{
  ## Include both glob matches and filenames without asterisk,
  ## in case some filenames without asterisk are not found
  from <- sort(unique(c(Sys.glob(from), from[!grepl("\\*", from)])))

  out <- mapply(file.copy, from, to, overwrite=TRUE,
                recursive=dir.exists(from), copy.date=TRUE)
  if(move)
    unlink(from, recursive=TRUE, force=TRUE)
  names(out) <- from

  invisible(out)
}
