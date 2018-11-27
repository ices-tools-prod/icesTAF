#' Remove Empty Directory
#'
#' Remove empty directory under any operating system.
#'
#' @param path a directory name.
#' @param recursive whether to remove empty subdirectories as well.
#'
#' @return
#' \code{TRUE} for success, \code{FALSE} for failure, invisibly.
#'
#' @note
#' The base function \code{unlink(dir, recursive=FALSE)} does not remove empty
#' directories in Windows and \code{unlink(dir, recursive=TRUE)} removes
#' non-empty directories, making it unsuitable for tidying up empty ones.
#'
#' @seealso
#' \code{\link{unlink}} with \code{recursive = TRUE} removes non-empty
#' directories.
#'
#' \code{\link{mkdir}} creates a new directory.
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

rmdir <- function(path, recursive=FALSE)
{
  if(length(path) > 1)
  {
    code <- sapply(path, rmdir, recursive=recursive)
    invisible(code)
  }
  else
  {
    if(recursive)
    {
      paths <- rev(c(path, dir(path, full.names=TRUE, recursive=TRUE,
                               include.dirs=TRUE)))
      code <- sapply(paths, rmdir, recursive=FALSE)
    }
    else
    {
      ## Not an existing directory
      if(!dir.exists(path))
      {
        code <- FALSE
      }
      ## Not an empty directory
      else if(length(dir(path,all.files=TRUE,no..=TRUE)) > 0)
      {
        code <- FALSE
      }
      ## Existing and empty
      else
      {
        unlink(path, recursive=TRUE)
        code <- TRUE
      }
    }
  }
  invisible(code)
}
