#' TAF Transpose
#'
#' Convert a table from TAF format to transposed crosstab format.
#'
#' @param x a data frame in TAF format.
#'
#' @return
#' A data frame with years as column names.
#'
#' @note
#' Transposing can be useful when comparing TAF tables to stock assessment
#' reports.
#'
#' @seealso
#' \code{\link{catage.taf}} describes the TAF format.
#'
#' \code{\link{taf2xtab}} converts a TAF table to crosstab format, without
#' transposing.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' taf2xtab(catage.taf)
#' tt(catage.taf)
#'
#' @export

tt <- function(x)
{
  as.data.frame(t(taf2xtab(x)))
}
