#' Show Message
#'
#' Show a message, as well as the current time.
#'
#' @param \dots passed to \code{message}.
#'
#' @seealso
#' \code{\link{message}} is the base function to show messages, without the
#' current time.
#'
#' \code{\link{sourceTAF}} reports progress using \code{msg}.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' msg("Running script.R")
#'
#' @export

msg <- function(...)
{
  message(format(Sys.time(), "[%H:%M:%S] "), ...)
}
