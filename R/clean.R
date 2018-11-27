#' Clean TAF Directories
#'
#' Remove TAF directories: \verb{data}, \verb{model}, \verb{output},
#' \verb{report}.
#'
#' @param dirs directories to delete.
#'
#' @note
#' The purpose of removing the directories is to make sure that subsequent TAF
#' scripts start by creating new empty directories.
#'
#' @seealso
#' \code{\link{mkdir}} and \code{\link{rmdir}}  create and remove
#' empty-directories.
#'
#' \code{\link{sourceTAF}} and \code{\link{sourceAll}} run TAF scripts.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' clean()
#' }
#'
#' @export

clean <- function(dirs=c("data", "model", "output", "report"))
{
  unlink(dirs, recursive=TRUE)
}
