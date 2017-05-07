#' Convert Crosstab Table to TAF Format
#'
#' Convert a table from crosstab format to TAF format.
#'
#' @param x a data frame in crosstab format.
#'
#' @return
#' A data frame in TAF format.
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
#' \code{\link{taf2xtab}} converts a TAF table to crosstab format.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' xtab2taf(catage.xtab)
#'
#' @export

xtab2taf <- function(x)
{
  y <- data.frame(Year=as.integer(row.names(x)), x, check.names=FALSE)
  row.names(y) <- NULL
  y
}
