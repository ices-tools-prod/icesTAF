#' Run All TAF Scripts as Needed
#'
#' Run core TAF scripts that have changed, or if previous steps were rerun.
#'
#' @param \dots passed to \code{\link{makeTAF}}.
#'
#' @return Logical vector indicating which scripts were run.
#'
#' @note
#' TAF scripts that will be run as needed: \verb{data.R}, \verb{model.R},
#' \verb{output.R}, and \verb{report.R}.
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

makeAll <- function(...)
{
  scripts <- c("data.R", "model.R", "output.R", "report.R")
  scripts <- scripts[file.exists(scripts)]

  out <- sapply(scripts, makeTAF, ...)
  if(length(out) == 0)
    out <- logical(0)

  invisible(out)
}
