#' Round Columns
#'
#' Round column values in a data frame.
#'
#' @param x a data frame.
#' @param cols column names.
#' @param digits number of decimal places.
#'
#' @return
#' A data frame similar to \code{x}, after rounding columns \code{cols} to the
#' number of \code{digits}.
#'
#' @note
#' Provides notation that is reliable and convenient for modifying a large
#' number of columns, not repeating column names twice.
#'
#' @seealso
#' \code{\link{round}} is the underlying function used to round numbers.
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
#' summary <- rnd(summary.taf, c("Fbar", "Fbar_lo", "Fbar_hi"), 2)
#'
#' @export

rnd <- function(x, cols, digits=0)
{
  x[cols] <- round(x[cols], digits)
  x
}
