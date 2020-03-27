#' Copy Files
#'
#' Copy or move files, overwriting existing files if necessary, and returning
#' the result invisibly.
#'
#' @param from source filenames, e.g. \code{*.csv}.
#' @param to destination filenames, or directory.
#' @param move whether to move instead of copy.
#' @param ignore whether to suppress error if source file does not exist.
#' @param quiet whether to suppress messages.
#'
#' @return \code{TRUE} for success, \code{FALSE} for failure, invisibly.
#'
#' @note
#' To prevent accidental loss of files, two safeguards are enforced when
#' \code{move = TRUE}:
#' \enumerate{
#' \item When moving files, the \code{to} argument must either have a filename
#'       extension or be an existing directory.
#' \item When moving many files to one destination, the \code{to} argument must
#'       be an existing directory.
#' }
#' If these conditions do not hold, no files are changed and an error is
#' returned.
#'
#' @seealso
#' \code{\link{file.copy}} and \code{\link{unlink}} are the underlying functions
#' used to copy and (if \code{move = TRUE}) delete files.
#'
#' \code{\link{file.rename}} is the base function to rename files.
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
#' @importFrom tools file_ext
#'
#' @export

cp <- function(from, to, move=FALSE, ignore=FALSE, quiet=TRUE)
{
  ## Include both glob matches and filenames without asterisk,
  ## in case some filenames without asterisk are not found
  from <- sort(unique(c(Sys.glob(from), from[!grepl("\\*", from)])))

  if(!quiet)
  {
    message(if(move) "Moving files:" else "Copying files:")
    message("  ", paste(from, to, sep=" -> ", collapse="\n  "))
  }

  if(move)
  {
    ## Safeguard 1: destination must have file_ext or exist as dir
    if(any(file_ext(to)=="" & !dir.exists(to)))
      stop("when moving, 'to' must have file extension or exist as directory")
    ## Safeguard 2: many-one, dir must exist
    if(length(from)>1 && length(to)==1 && !dir.exists(to))
      stop("when moving many -> one, 'to' must be an existing directory")
  }

  if(any(!file.exists(from)) && !ignore)
    stop("file '", from[match(FALSE, file.exists(from))], "' does not exist")

  out <- suppressWarnings(mapply(file.copy, from, to, overwrite=TRUE,
                                 recursive=dir.exists(from), copy.date=TRUE))
  if(move)
    unlink(from, recursive=TRUE, force=TRUE)
  names(out) <- from

  invisible(out)
}
