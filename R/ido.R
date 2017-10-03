#' Invisible Dev Off
#'
#' Close graphics device quietly.
#'
#' @param \dots passed to \code{dev.off}.
#'
#' @note
#' A simple convenience function to shorten
#' \preformatted{invisible(dev.off())}
#' to
#' \preformatted{ido()}
#'
#' @seealso
#' \code{\link{dev.off}} is the underlying function used to close a graphics
#' device.
#'
#' \code{\link{tafpng}} opens a PNG graphics device.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' tafpng("myplot")
#' plot(1)
#' ido()
#' }
#'
#' @importFrom grDevices dev.off
#'
#' @export

ido <- function(...)
{
  invisible(dev.off(...))
}
