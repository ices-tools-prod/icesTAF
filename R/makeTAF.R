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
#' @note
#' Any underlying scripts are automatically included if they share the same
#' filename prefix, followed by an underscore. For example, when determining
#' whether a script \verb{data.R} should be run, this function checks whether
#' \verb{data_foo.R} and \verb{data_bar.R} have been recently modified.
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
#' makeTAF("model.R")
#' }
#'
#' @export

makeTAF <- function(script, ...)
{
  script <- basename(script)
  out <- switch(script,
                "data.R"=make("data.R",
                              dir(pattern="^data_.*\\.R$"),
                              "data", engine=sourceTAF, ...),
                "model.R"=make("model.R",
                               c("data",dir(pattern="^model_.*\\.R$")),
                               "model", engine=sourceTAF, ...),
                "output.R"=make("output.R",
                                c("model",dir(pattern="^output_.*\\.R$")),
                                "output", engine=sourceTAF, ...),
                "report.R"=make("report.R",
                                c("output",dir(pattern="^report_.*\\.R$")),
                                "report", engine=sourceTAF, ...),
                FALSE)
  invisible(out)
}
