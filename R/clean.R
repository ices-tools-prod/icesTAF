#' Clean TAF Directories
#'
#' Remove working TAF directories (\verb{data}, \verb{model}, \verb{output},
#' \verb{report}), \verb{bootstrap}, or other directories.
#'
#' @param dirs directories to delete.
#' @param force passed to \code{software} and \code{clean.library} if any of the
#'        \code{dirs} is \code{"bootstrap"}.
#'
#' @note
#' The purpose of removing the directories is to make sure that subsequent TAF
#' scripts start by creating new empty directories.
#'
#' If any of the \code{dirs} is \code{"bootstrap"} it is treated specially.
#' Instead of completely removing the \verb{bootstrap} directory, only the
#' subdirectories \verb{data} is removed, while \code{clean.software} and
#' \code{clean.library} are used to clean the \verb{bootstrap/software} and
#' \verb{bootstrap/library} subdirectories. This protects the subdirectory
#' \verb{bootstrap/initial} and \verb{*.bib} metadata files from being
#' accidentally deleted.
#'
#' @seealso
#' \code{\link{clean.software}} selectively removes software from
#' \verb{bootstrap/software}.
#'
#' \code{\link{clean.library}} selectively removes packages from
#' \verb{bootstrap/library}.
#'
#' \code{\link{clean.data}} selectively removes data from \verb{bootstrap/data}.
#'
#' \code{\link{mkdir}} and \code{\link{rmdir}} create and remove empty
#' directories.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' clean()
#' }
#'
#' @export

clean <- function(dirs=c("data", "model", "output", "report"), force=FALSE)
{
  ## Convert "bootstrap/" to "bootstrap", so clean("bootstrap/") doesn't go wild
  dirs <- sub("/$", "", dirs)

  if("bootstrap" %in% dirs)
  {
    ## An odd directory called 'library:' can appear in Linux
    unlink("bootstrap/library:", recursive=TRUE)
    clean.software("bootstrap/software", force=force)
    clean.library("bootstrap/library", force=force)
    clean.data("bootstrap/data", force=force)
    dirs <- dirs[dirs != "bootstrap"]
  }

  unlink(dirs, recursive=TRUE)
}
