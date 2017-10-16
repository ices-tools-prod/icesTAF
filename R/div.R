#' Divide Columns
#'
#' Divide column values in a data frame with a common number.
#'
#' @param x a data frame.
#' @param cols column names.
#' @param by a number to divide with.
#'
#' @return
#' A data frame similar to \code{x}, after dividing columns \code{cols} by the
#' number \code{by}.
#'
#' @seealso
#' \code{\link{sweep}} and \code{\link{transform}} can also be used to
#' recalculate column values, using a more general and verbose syntax.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' summary <- data.frame(Year=2000:2001, Rec=c(12345,23456), SSB=c(98765,87654),
#'                       Catch=c(12345,23456), Fbar=c(1.2345,2.3456))
#' summary <- div(summary, c("Rec","SSB","Catch"))
#'
#' @export

div <- function(x, cols, by=1000)
{
  x[cols] <- x[cols] / by
  x
}
