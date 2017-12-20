#' Run TAF Script If Needed
#'
#' Run a TAF script if the target directory is either older than the script, or
#' older than the directory of the previous TAF step.
#'
#' @param script TAF script filename.
#' @param \dots passed to \code{\link{make}} and \code{\link{sourceTAF}}.
#'
#' @return \code{TRUE} or \code{FALSE}, indicating whether the script was run.
#'
#' @seealso
#' \code{\link{sourceTAF}} runs a TAF script.
#'
#' \code{\link{make}} runs an R script if needed.
#'
#' \code{\link{makeAll}} runs all TAF scripts as needed.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' makeTAF("model.R")
#' }
#'
#' @export

makeTAF <- function(script, ...)
{
  owd <- setwd(dirname(script))
  on.exit(setwd(owd))
  script <- basename(script)
  out <- switch(script,
                "data.R"=make("data.R", NULL, "data", engine=sourceTAF, ...),
                "input.R"=make("input.R", "data", "input", engine=sourceTAF, ...),
                "model.R"=make("model.R", "input", "model", engine=sourceTAF, ...),
                "output.R"=make("output.R", "model", "output", engine=sourceTAF, ...),
                "report.R"=make("report.R", "output", "report", engine=sourceTAF, ...),
                FALSE)
  invisible(out)
}
