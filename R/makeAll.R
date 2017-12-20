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
#' \code{\link{make}} runs a TAF script if needed.
#'
#' \code{\link{sourceAll}} runs all TAF scripts in a directory.
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

  data <- input <- model <- output <- report <- FALSE

  data <- if(file.exists("data.R"))
            make("data.R", NULL, "data", ...)
  input <- if(file.exists("input.R"))
             make("input.R", "data", "input", ...)
  model <- if(file.exists("model.R"))
             make("model.R", "input", "model", ...)
  output <- if(file.exists("output.R"))
              make("output.R", "model", "output", ...)
  report <- if(file.exists("report.R"))
              make("report.R", "output", "report", ...)

  out <- c(data, input, model, output, report)
  names(out) <- c("data.R", "input.R", "model.R", "output.R", "report.R")

  invisible(out)
}
