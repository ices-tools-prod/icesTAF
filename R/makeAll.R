#' Run All TAF Scripts as Needed
#'
#' Run TAF scripts that have changed, or if previous steps were rerun.
#'
#' @param path directory containing TAF scripts.
#' @param \dots passed to \code{\link{make}}.
#'
#' @return Logical vector indicating which scripts were run.
#'
#' @note
#' TAF scripts that will be run as needed: \code{data.R}, \code{input.R},
#' \code{model.R}, \code{output.R}, and \code{report.R}.
#'
#' @seealso
#' \code{\link{source}} runs any R script, \code{\link{sourceTAF}} is more
#' convenient for running a TAF script, and \code{\link{sourceAll}} runs all TAF
#' scripts.
#'
#' \code{\link{make}}, \code{\link{makeTAF}}, and \code{\link{makeAll}} are
#' similar to the \code{source} functions, except they avoid repeating tasks
#' that have already been run.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' makeAll()
#' }
#'
#' @export

makeAll <- function(path=".", ...)
{
  owd <- setwd(path)
  on.exit(setwd(owd))

  scripts <- c("data.R", "input.R", "model.R", "output.R", "report.R")
  scripts <- scripts[file.exists(scripts)]

  ok <- sapply(scripts, makeTAF, ...)
  if(length(ok) == 0)
    ok <- logical(0)

  invisible(ok)
}
