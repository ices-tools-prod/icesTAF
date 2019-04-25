#' Copy Files
#'
#' Copy files, overwriting existing files if necessary, and returning the result
#' invisibly.
#'
#' @param from source filenames, e.g. \code{*.csv}.
#' @param to destination filenames, or directory.
#'
#' @return \code{TRUE} for success, \code{FALSE} for failure, invisibly.
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
#'
#' ## Copy directory tree
#' cp(system.file(package="datasets"), ".")
#' mkdir("everything")
#' cp("datasets/*", "everything")
#' }
#'
#' @importFrom tools file_ext
#'
#' @export

cp <- function(from, to)
{
  ## Include both glob matches and filenames without asterisk,
  ## in case some filenames without asterisk are not found
  from <- sort(unique(c(Sys.glob(from), from[!grepl("\\*", from)])))

  out <- mapply(file.copy, from, to, overwrite=TRUE,
                recursive=dir.exists(from), copy.date=TRUE)

  invisible(out)
}
