#' Period
#'
#' Paste two years to form a \code{period} string.
#'
#' @param x the first year, vector of years, matrix, or data frame.
#' @param y the last year, if \code{x} is only the first year.
#'
#' @details
#' If \code{x} is a vector or a data frame, then the lowest and highest years
#' are used, and \code{y} is ignored.
#'
#' If \code{x} is a matrix or data frame, this function looks for years in the
#' first column. If the values of the first column do not look like years (four
#' digits), then it looks for years in the row names.
#'
#' @return A string of the form \code{"1990-2000"}.
#'
#' @note This function can be useful when working with \code{\link{draft.data}}.
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
#' period(c(1963, 1970))
#' period(1963:1970)
#'
#' period(range(catage.taf$Year))
#' period(catage.taf$Year)
#' period(catage.taf)
#' period(catage.xtab)
#'
#' @export

period <- function(x, y=NULL)
{
  if(is.matrix(x) || is.data.frame(x))
  {
    pattern <- "^[12][0-9][0-9][0-9]$"
    if(all(grepl(pattern, x[,1])))
      x <- x[,1]
    else if(all(grepl(pattern, row.names(x))))
      x <- row.names(x)
    else
      stop("data frame must contain years in first column or row names")
  }
  if(length(x) > 1)
  {
    y <- max(x)
    x <- min(x)
  }
  out <- if(!is.null(y) && y!=x) paste(range(x,y), collapse="-")
         else as.character(x)
  out
}
