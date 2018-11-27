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
#' If any of the \code{dirs} is \code{"bootstrap"} it is treated specially.
#' Instead of completely removing the \verb{bootstrap} directory, only the
#' subdirectories \verb{data}, \verb{library}, and \verb{software} are removed.
#' This protects the subdirectory \verb{bootstrap/initial} and \verb{*.bib}
#' metadata files from being accidentally deleted.
#'
#' @seealso
#' \code{\link{mkdir}} and \code{\link{rmdir}} create and remove empty
#' directories.
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
  if("bootstrap" %in% dirs)
  {
    unlink(c("bootstrap/data", "bootstrap/library", "bootstrap/software"),
           recursive=TRUE)
    dirs <- dirs[dirs != "bootstrap"]
  }
  unlink(dirs, recursive=TRUE)
}
