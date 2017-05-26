#' Clean TAF Directories
#'
#' Remove directories \file{db}, \file{input}, \file{model}, \file{output}, and
#' \file{upload}.
#'
#' @param path location where directories are found.
#'
#' @note
#' The purpose of removing the directories is to make sure that subsequent TAF
#' scripts start by creating new empty directories.
#'
#' @seealso
#' \code{\link{sourceTAF}} runs a TAF script.
#'
#' \code{\link{sourceAtoZ}} runs all TAF scripts in a directory.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' clean()
#' }
#'
#' @export

clean <- function(path=".")
{
  owd <- setwd(path)
  on.exit(setwd(owd))
  unlink(c("db","input","model","output","upload"), recursive=TRUE)
}
