#' Divide Columns
#'
#' Divide column values in a data frame with a common number.
#'
#' @param x a data frame.
#' @param cols column names, or column indices.
#' @param by a number to divide with.
#' @param grep whether \code{cols} is a regular expression.
#' @param \dots passed to \code{grep()}.
#'
#' @return
#' A data frame similar to \code{x}, after dividing columns \code{cols} by the
#' number \code{by}.
#'
#' @note
#' Provides notation that is convenient for modifying many columns at once.
#'
#' @seealso
#' \code{\link{transform}} can also be used to recalculate column values, using
#' a more general and verbose syntax.
#'
#' \code{\link{grep}} is the underlying function used to match column names if
#' \code{grep} is \code{TRUE}.
#'
#' \code{\link{rnd}} is a similar function that rounds columns.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' # These are equivalent:
#'
#' x1 <- div(summary.taf, c("Rec","Rec_lo","Rec_hi",
#'                          "TSB","TSB_lo","TSB_hi",
#'                          "SSB","SSB_lo","SSB_hi",
#'                          "Removals","Removals_lo","Removals_hi"))
#'
#' x2 <- div(summary.taf, "Rec|TSB|SSB|Removals", grep=TRUE)
#'
#' x3 <- div(summary.taf, "Year|Fbar", grep=TRUE, invert=TRUE)
#'
#' # Less reliable in scripts if columns have been added/deleted/reordered:
#'
#' x4 <- div(summary.taf, 2:13)
#'
#' @export

div <- function(x, cols, by=1000, grep=FALSE, ...)
{
  if(grep)
    cols <- grep(cols, names(x), ...)
  x[cols] <- mapply("/", x[cols], by)
  x
}
