#' Run TAF Script
#'
#' Run a TAF script and return to the original directory. Optionally start with
#' an empty workspace.
#'
#' @param script script filename.
#' @param rm whether to remove all objects from the global environment before
#'        the script is run.
#' @param clean whether to remove the corresponding TAF directory before running
#'        the script.
#' @param quiet whether to suppress messages reporting progress.
#'
#' @details
#' By default, TAF scripts are run with \code{rm = TRUE} to make sure each
#' script starts with an empty workspace. Likewise, the default
#' \code{clean = TRUE} makes sure that the script starts by creating a new empty
#' directory.
#'
#' @return
#' Invisible \code{TRUE} or \code{FALSE}, indicating whether the script ran
#' without errors.
#'
#' @note
#' Commands within a script may change the working directory, but
#' \code{sourceTAF} guarantees that after running a script, the working
#' directory reported by \code{getwd()} is the same before and after running a
#' script.
#'
#' @seealso
#' \code{\link{source}} is the base function to run R scripts.
#'
#' \code{\link{make}} runs a TAF script if needed.
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

sourceTAF <- function(script, rm=TRUE, clean=TRUE, quiet=FALSE)
{
  if(rm)
    rm(list=ls(.GlobalEnv), pos=.GlobalEnv)
  if(clean && dir.exists(file_path_sans_ext(script)))
    unlink(file_path_sans_ext(script), recursive=TRUE)
  if(!quiet)
    msg("Running ", script, " ...")

  owd <- setwd(dirname(script))
  on.exit(setwd(owd))
  result <- try(source(basename(script)))

  ok <- class(result) != "try-error"
  if(!quiet)
    message(if(ok) "Done" else "Failed")
  invisible(ok)
}
