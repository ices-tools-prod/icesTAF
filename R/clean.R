#' Clean TAF Directories
#'
#' Remove working TAF directories (\verb{data}, \verb{model}, \verb{output},
#' \verb{report}), \verb{bootstrap}, or other directories.
#'
#' @param dirs directories to delete.
#'
#' @note
#' The purpose of removing the directories is to make sure that subsequent TAF
#' scripts start by creating new empty directories.
#'
#' If any of the \code{dirs} is \code{"bootstrap"} it is treated specially.
#' Instead of completely removing the \verb{bootstrap} directory, only the
#' subdirectories \verb{data} and \verb{software} are removed, while
#' \code{clean.library} is used to clean the \verb{library} subdirectory. This
#' protects the subdirectory \verb{bootstrap/initial} and \verb{*.bib} metadata
#' files from being accidentally deleted.
#'
#' An explicit \code{clean("bootstrap/library")} removes that directory
#' completely.
#'
#' @seealso
#' \code{\link{clean.library}} selectively removes packages from
#' \verb{bootstrap/library}.
#'
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
  ## Convert "bootstrap/" to "bootstrap", so clean("bootstrap/") doesn't go wild
  dirs <- sub("/$", "", dirs)

  if("bootstrap" %in% dirs)
  {
    ## An odd directory called 'library:' can appear in Linux
    unlink(c("bootstrap/data", "bootstrap/library:", "bootstrap/software"),
           recursive=TRUE)
    clean.library("bootstrap/library")
    dirs <- dirs[dirs != "bootstrap"]
  }

  unlink(dirs, recursive=TRUE)
}
