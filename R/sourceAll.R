#' Run All TAF Scripts
#'
#' Run core TAF scripts in current directory.
#'
#' @param \dots passed to \code{\link{sourceTAF}}.
#'
#' @return Logical vector, indicating which scripts ran without errors.
#'
#' @note
#' TAF scripts that will be run if they exist: \verb{data.R}, \verb{model.R},
#' \verb{output.R}, and \verb{report.R}.
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

sourceAll <- function(...)
{
  scripts <- c("data.R", "model.R", "output.R", "report.R")
  scripts <- scripts[file.exists(scripts)]

  ok <- sapply(scripts, sourceTAF, ...)
  if(length(ok) == 0)
    ok <- logical(0)

  invisible(ok)
}
