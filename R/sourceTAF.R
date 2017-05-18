#' Run TAF Script
#'
#' Run an R script. Optionally start by cleaning the workspace and setting the
#' working directory.
#'
#' @param script script filename.
#' @param rm whether to remove all files from the global environment, before the
#'        script is run.
#' @param wd path to set as the working directory, or \code{NULL} to use the
#'        current working directory.
#' @param quiet whether to suppress messages reporting progress.
#'
#' @details
#' TAF scripts use \code{rm=TRUE} to make sure each script starts with an empty
#' workspace. The default \code{rm=FALSE} is mainly to prevent accidental loss
#' of work by users not familiar with the function.
#'
#' TAF scripts use a \code{taf.root} option to set the working directory. If
#' this option is not set and \code{wd=getOption("taf.root")}, it is equivalent
#' to passing \code{wd=NULL} which uses the current working directory.
#'
#' @return
#' Invisible \code{TRUE} if script ran without errors.
#'
#' @seealso
#' \code{\link{source}} is the base function to run R scripts.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' write("print(pi)", "script.R")
#' source("script.R")
#' sourceTAF("script.R")
#' }
#'
#' @export

sourceTAF <- function(script, rm=FALSE, wd=getOption("taf.root"), quiet=FALSE)
{
  if(rm)
    rm(list=ls(.GlobalEnv), pos=.GlobalEnv)
  if(!is.null(wd))
    setwd(wd)
  if(!quiet)
    message("* Running ", script, " ...")
  source(script)
  if(!quiet)
    message("Done")
  invisible(TRUE)
}
