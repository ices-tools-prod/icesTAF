#' Round Columns
#'
#' Round column values in a data frame.
#'
#' @param x a data frame.
#' @param cols column names, or column indices.
#' @param digits number of decimal places.
#' @param grep whether \code{cols} is a regular expression.
#' @param \dots passed to \code{grep()}.
#'
#' @return
#' A data frame similar to \code{x}, after rounding columns \code{cols} to the
#' number of \code{digits}.
#'
#' @note
#' Provides notation that is convenient for modifying many columns at once.
#'
#' @seealso
#' \code{\link{round}} is the underlying function used to round numbers.
#'
#' \code{\link{grep}} is the underlying function used to match column names if
#' \code{grep} is \code{TRUE}.
#'
#' \code{\link{div}} is a similar function that divides columns with a common
#' number.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' The \pkg{icesAdvice} package provides the \code{\link[icesAdvice]{icesRound}}
#' function to round values for ICES advice sheets.
#'
#' @examples
#' # These are equivalent:
#'
#' x1 <- rnd(summary.taf, c("Rec","Rec_lo","Rec_hi",
#'                          "TSB","TSB_lo","TSB_hi",
#'                          "SSB","SSB_lo","SSB_hi",
#'                          "Removals","Removals_lo","Removals_hi"))
#' x1 <- rnd(x1, c("Fbar","Fbar_lo","Fbar_hi"), 3)
#'
#' x2 <- rnd(summary.taf, "Rec|TSB|SSB|Removals", grep=TRUE)
#' x2 <- rnd(x2, "Fbar", 3, grep=TRUE)
#'
#' x3 <- rnd(summary.taf, "Fbar", grep=TRUE, invert=TRUE)
#' x3 <- rnd(x3, "Fbar", 3, grep=TRUE)
#'
#' # Less reliable in scripts if columns have been added/deleted/reordered:
#'
#' x4 <- rnd(summary.taf, 2:13)
#' x4 <- rnd(x4, 14:16, 3)
#'
#' @export

rnd <- function(x, cols, digits=0, grep=FALSE, ...)
{
  if(grep)
    cols <- grep(cols, names(x), ...)
  x[cols] <- round(x[cols], digits)
  x
}
