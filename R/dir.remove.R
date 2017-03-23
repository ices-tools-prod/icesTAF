#' Remove Empty Directory
#'
#' Remove empty directories under any operating system.
#'
#' @param path a directory name.
#' @param recursive whether to remove empty subdirectories as well.
#'
#' @return
#' 0 for success, 1 for failure, invisibly.
#'
#' @note
#' To tidy up a project workspace, it can be useful to remove empty directories,
#' while leaving non-empty directories intact.
#'
#' The base function \code{unlink(dir, recursive=FALSE)} does not remove empty
#' directories in Windows and \code{unlink(dir, recursive=TRUE)} removes
#' non-empty directories, making it unsuitable for tidying up empty ones.
#'
#' @seealso
#' \code{\link{unlink}} can remove non-empty directories.
#'
#' \code{\link{dir.create}} creates an empty directory.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' dir.create("emptydir")
#' dir.remove("emptydir")
#'
#' dir.create("outer/inner", recursive=TRUE)
#' dir.remove("outer/inner", recursive=TRUE)
#' }
#'
#' @export

dir.remove <- function(path, recursive=FALSE)
{
  if(recursive)
  {
    paths <- rev(c(path, dir(path, full.names=TRUE, recursive=TRUE,
                             include.dirs=TRUE)))
    code <- sapply(paths, dir.remove, recursive=FALSE)
  }
  else
  {
    ## Not an existing directory
    if(!dir.exists(path))
    {
      code <- 1
    }
    ## Not an empty directory
    else if(length(dir(path,all.files=TRUE,no..=TRUE)) > 0)
    {
      code <- 1
    }
    ## Existing and empty
    else
    {
      unlink(path, recursive=TRUE)
      code <- 0
    }
  }
  invisible(code)
}
