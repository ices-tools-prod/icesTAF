#' Divide Columns
#'
#' Divide column values in a data frame with a common number.
#'
#' @param x a data frame.
#' @param cols column names, or column indices.
#' @param by a number to divide with.
#' @param grep whether \code{cols} is a regular expression.
#'
#' @return
#' A data frame similar to \code{x}, after dividing columns \code{cols} by the
#' number \code{by}.
#'
#' @note
#' Provides notation that is reliable and convenient for modifying many columns
#' at once.
#'
#' @seealso
#' \code{\link{transform}} can also be used to recalculate column values, using
#' a more general and verbose syntax.
#'
#' \code{\link{grep}} is the underlying function used to match column names if
#' \code{grep} is \code{TRUE}.
#'
#' \code{\link{rnd}} is a similar function to round columns.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' # Equivalent alternatives:
#'
#' summary <- div(summary.taf,
#'   c("Rec","Rec_lo","Rec_hi","TSB","TSB_lo","TSB_hi","SSB","SSB_lo","SSB_hi"))
#'
#' summary <- div(summary.taf, "Rec|TSB|SSB", grep=TRUE)
#'
#' @export

div <- function(x, cols, by=1000, grep=FALSE)
{
  if(grep)
    cols <- grep(cols, names(x))
  x[cols] <- x[cols] / by
  x
}
