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
#' @note
#' Provides notation that is reliable and convenient for modifying a large
#' number of columns, not repeating column names twice.
#'
#' @seealso
#' \code{\link{sweep}} and \code{\link{transform}} can also be used to
#' recalculate column values, using a more general and verbose syntax.
#'
#' \code{\link{rnd}} is a similar function to round columns.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' summary <- div(summary.taf,
#'   c("Rec","Rec_lo","Rec_hi","TSB","TSB_lo","TSB_hi","SSB","SSB_lo","SSB_hi"))
#'
#' @export

div <- function(x, cols, by=1000)
{
  x[cols] <- x[cols] / by
  x
}
