#' Axis Limits
#'
#' Compute axis limits. The lower limit is 0 and the upper limit is determined
#' by the highest data value, times a multiplier.
#'
#' @param x a vector of data values.
#' @param mult a number to multiply with the highest data value.
#'
#' @return A vector of length two, which can be used as axis limits.
#'
#' @seealso
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' plot(rivers, ylim=lim(rivers))
#'
#' @export

lim <- function(x, mult=1.1)
{
  c(0, mult*max(x,na.rm=TRUE))
}
