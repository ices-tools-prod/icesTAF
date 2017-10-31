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
#' Provides notation that is reliable and convenient for modifying many columns
#' at once.
#'
#' @seealso
#' \code{\link{round}} is the underlying function used to round numbers.
#'
#' \code{\link{grep}} is the underlying function used to match column names if
#' \code{grep} is \code{TRUE}.
#'
#' \code{\link{div}} is a similar function to divide columns with a common
#' number.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' The \pkg{icesAdvice} package provides the \code{\link[icesAdvice]{icesRound}}
#' function to round values for ICES advice sheets.
#'
#' @examples
#' # Equivalent alternatives:
#'
#' summary <- rnd(summary.taf, c("Fbar", "Fbar_lo", "Fbar_hi"), 2)
#'
#' summary <- rnd(summary.taf, "Fbar", 2, grep=TRUE)
#'
#' @export

rnd <- function(x, cols, digits=0, grep=FALSE, ...)
{
  if(grep)
    cols <- grep(cols, names(x), ...)
  x[cols] <- round(x[cols], digits)
  x
}
