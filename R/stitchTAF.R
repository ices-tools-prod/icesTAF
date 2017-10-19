#' Stitch a TAF Script into an HTML report
#'
#' Use the knitr function \code{stitch()} to generate an html report of a single
#' TAF script.
#'
#' @param script script filename.
#' @param rm whether to remove all objects from the global environment before
#'        the script is stitched.
#' @param quiet whether to suppress messages reporting progress.
#'
#' By default, TAF scripts are stitched with \code{rm = TRUE} to make sure each
#' script starts with an empty workspace.
#'
#' @return
#' Invisible \code{TRUE} or \code{FALSE}, indicating whether the script ran
#' without errors.
#'
#' @note
#' Commands within a script may change the working directory, but
#' \code{stitchTAF} guarantees that after running a script, the working
#' directory reported by \code{getwd()} is the same before and after running a
#' script.
#'
#' @seealso
#' \code{\link{stitch}} is the base function to stitch R scripts.
#'
#' \code{\link{make}} runs a TAF script if needed.
#'
#' \code{\link{sourceTAF}} runs a single TAF script.
#'
#' \code{\link{sourceAll}} runs all TAF scripts in a directory.
#'
### \code{\link{stitchAtoZ}} stitches all TAF scripts in a directory into an HTML report.
###
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @export

#' @import knitr
stitchTAF <- function(script, rm=TRUE, quiet=FALSE)
{
  if (rm)
    rm(list=ls(.GlobalEnv), pos=.GlobalEnv)
  if (!quiet)
    msg("Stitching ", script, " ...")

  owd <- setwd(dirname(script))
  on.exit(setwd(owd))
  result <- try(knitr::stitch_rhtml(basename(script)))

  ok <- class(result) != "try-error"
  if (!quiet)
    message(if(ok) "Done" else "Failed")
  invisible(ok)
}
