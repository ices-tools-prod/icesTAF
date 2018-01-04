#' Run All TAF Scripts
#'
#' Run all TAF scripts found in a directory.
#'
#' @param path directory containing TAF scripts.
#' @param \dots passed to \code{\link{sourceTAF}}.
#'
#' @return Logical vector, indicating which scripts ran without errors.
#'
#' @note
#' TAF scripts that will be run if they exist: \code{data.R}, \code{input.R},
#' \code{model.R}, \code{output.R}, and \code{report.R}.
#'
#' @seealso
#' \code{\link{sourceTAF}} runs a TAF script.
#'
#' \code{\link{makeAll}} runs all TAF scripts as needed.
#'
#' \code{\link{clean}} cleans TAF directories.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' sourceAll()
#' }
#'
#' @export

sourceAll <- function(path=".", ...)
{
  owd <- setwd(path)
  on.exit(setwd(owd))

  scripts <- c("data.R", "input.R", "model.R", "output.R", "report.R")
  scripts <- scripts[file.exists(scripts)]

  ok <- sapply(scripts, sourceTAF, ...)
  if(length(ok) == 0)
    ok <- logical(0)

  invisible(ok)
}
