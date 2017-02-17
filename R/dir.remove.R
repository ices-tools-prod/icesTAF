#' Remove Empty Directory
#'
#' Remove an empty directory under any operating system.
#'
#' @param path a directory name.
#'
#' @return
#' 0 for success, 1 for failure, invisibly.
#'
#' @seealso
#' \code{\link{unlink}} can remove a non-empty directory.
#'
#' \code{\link{dir.create}} creates an empty directory.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' dir.create("emptydir")
#' dir.remove("emptydir")
#' }
#'
#' @export

dir.remove <- function(path)
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
  invisible(code)
}
