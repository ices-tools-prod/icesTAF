#' Convert TAF Table to Crosstab Format
#'
#' Convert a table from TAF format to crosstab format.
#'
#' @param x a data frame in TAF format.
#'
#' @return
#' A data frame with years as row names.
#'
#' @note
#' TAF stores tables as data frames with a year column, as seen in stock
#' assessment reports. The crosstab format can be more convenient for analysis
#' and producing plots.
#'
#' @seealso
#' \code{\link{catage.taf}} and \code{\link{catage.xtab}} describe the TAF and
#' crosstab formats.
#'
#' \code{\link{tt}} converts a TAF table to transposed crosstab format.
#'
#' \code{\link{xtab2taf}} converts a crosstab table to TAF format.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' taf2xtab(catage.taf)
#'
#' @export

taf2xtab <- function(x)
{
  data.frame(x[-1], row.names=x[[1]], check.names=FALSE)
}
