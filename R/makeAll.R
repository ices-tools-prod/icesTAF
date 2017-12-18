#' Run All TAF Scripts as Needed
#'
#' Run TAF scripts that have changed, or if previous steps were rerun.
#'
#' @param path directory containing TAF scripts.
#' @param quiet whether to suppress messages when nothing is done.
#' @param debug whether to show a diagnostic table of files and time last
#'        modified.
#'
#' @return
#' Logical vector indicating which scripts were run.
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
#' @importFrom stats setNames
#'
#' @export

makeAll <- function(path=".", quiet=TRUE, debug=FALSE)
{
  data <- input <- model <- output <- report <- FALSE
  data <- if(file.exists("data.R"))
            make("data.R", "data.R", "data",
                 quiet=quiet, debug=debug)
  input <- if(file.exists("input.R"))
             make("input.R", c("data", "input.R"), "input",
                  quiet=quiet, debug=debug)
  model <- if(file.exists("model.R"))
             make("model.R", c("input", "model.R"), "model",
                  quiet=quiet, debug=debug)
  output <- if(file.exists("output.R"))
              make("output.R", c("model", "output.R"), "output",
                   quiet=quiet, debug=debug)
  report <- if(file.exists("report.R"))
              make("report.R", c("output", "report.R"), "report",
                   quiet=quiet, debug=debug)
  out <- setNames(c(data, input, model, output, report),
                  c("data", "input", "model", "output", "report"))
  invisible(out)
}
