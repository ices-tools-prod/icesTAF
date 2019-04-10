#' Period
#'
#' Paste two years to form a \code{period} string.
#'
#' @param x the first year, a vector of years, or a data frame containing
#'        a \code{Year} column.
#' @param y the last year, if \code{x} is only the first year.
#'
#' @details
#' If \code{x} is a vector or a data frame, the lowest and highest years are
#' used, and \code{y} is ignored.
#'
#' @return
#' A string of the form \code{"1990-2000"}.
#'
#' @note
#' This function can be useful when working with \code{\link{draft.data}}.
#'
#' @seealso
#' \code{\link{paste}} is the underlying function to paste strings.
#'
#' \code{\link{draft.data}} has an argument called \code{period}.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' period(1963, 1970)
#' period(range(catage.taf$Year))
#' period(catage.taf$Year)
#' period(catage.taf)
#'
#' @export

period <- function(x, y=NULL)
{
  if(is.data.frame(x))
    x <- x$Year
  if(length(x) > 1)
  {
    y <- max(as.numeric(x))
    x <- min(as.numeric(x))
  }
  out <- if(!is.null(y) && y!=x) paste(range(x,y), collapse="-")
         else as.character(x)
  out
}
