#' Run TAF Script
#'
#' Run a TAF script and return to the original directory.
#'
#' @param script script filename.
#' @param rm whether to remove all objects from the global environment before
#'        and after the script is run.
#' @param clean whether to \code{\link{clean}} the target directory before
#'        running the script.
#' @param quiet whether to suppress messages reporting progress.
#'
#' @details
#' The default value of \code{rm = FALSE} is to protect users from accidental
#' loss of work, but the TAF server always runs with \code{rm = TRUE} to make
#' sure that only files, not objects, are carried over between scripts.
#'
#' Likewise, the TAF server runs with \code{clean = TRUE} to make sure that the
#' script starts with a clean directory. The target directory of a TAF script
#' has the same filename prefix as the script: \verb{data.R} creates \file{data}
#' etc.
#'
#' @return
#' \code{TRUE} or \code{FALSE}, indicating whether the script ran without
#' errors.
#'
#' @note
#' Commands within a script (such as \code{setwd}) may change the working
#' directory, but \code{sourceTAF} guarantees that after running a script, the
#' working directory reported by \code{getwd()} is the same before and after
#' running a script.
#'
#' @seealso
#' \code{\link{source}} is the base function to run R scripts.
#'
#' \code{\link{makeTAF}} runs a TAF script if needed.
#'
#' \code{\link{sourceAll}} runs all TAF scripts in a directory.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' write("print(pi)", "script.R")
#' source("script.R")
#' sourceTAF("script.R")
#' file.remove("script.R")
#' }
#'
#' @importFrom tools file_path_sans_ext
#'
#' @export

sourceTAF <- function(script, rm=FALSE, clean=TRUE, quiet=FALSE)
{
  if(rm)
    rm(list=ls(.GlobalEnv), pos=.GlobalEnv)
  if(clean && dir.exists(file_path_sans_ext(script)))
    clean(file_path_sans_ext(script))
  if(!quiet)
    msg(script, " running...")

  owd <- setwd(dirname(script))
  on.exit(setwd(owd))
  result <- try(source(basename(script)))
  ok <- class(result) != "try-error"
  if(!quiet)
    msg("  ", script, if(ok) " done" else " failed")

  if(rm)
    rm(list=ls(.GlobalEnv), pos=.GlobalEnv)

  invisible(ok)
}
