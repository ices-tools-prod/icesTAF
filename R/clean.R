#' Clean TAF Directories
#'
#' Remove TAF directories: \verb{data}, \verb{input}, \verb{model},
#' \verb{output}, \verb{report}.
#'
#' @param dirs directories to delete.
#'
#' @note
#' The purpose of removing the directories is to make sure that subsequent TAF
#' scripts start by creating new empty directories.
#'
#' @seealso
#' \code{\link{sourceTAF}} runs a TAF script.
#'
#' \code{\link{sourceAll}} runs all TAF scripts in a directory.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' clean()
#' }
#'
#' @export

clean <- function(dirs=c("data","input","model","output","report"))
{
  unlink(dirs, recursive=TRUE)
}
