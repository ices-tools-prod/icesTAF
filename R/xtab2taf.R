#' Convert Crosstab Table to TAF Format
#'
#' Convert a table from crosstab format to TAF format.
#'
#' @param x a data frame in crosstab format.
#' @param colname name for first column.
#'
#' @return A data frame in TAF format.
#'
#' @note
#' TAF stores tables as data frames, usually with a year column as seen in stock
#' assessment reports. The crosstab format can be more convenient for analysis
#' and producing plots.
#'
#' @seealso
#' \code{\link{catage.xtab}} and \code{\link{catage.taf}} describe the crosstab
#' and TAF formats.
#'
#' \code{\link{taf2xtab}} converts a TAF table to crosstab format.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' xtab2taf(catage.xtab)
#'
#' @importFrom utils type.convert
#'
#' @export

xtab2taf <- function(x, colname="Year")
{
  if(is.table(x))
    x <- unclass(x)  # handle xtabs() output
  y <- data.frame(type.convert(as.character(row.names(x)),as.is=TRUE), x,
                  check.names=FALSE)
  names(y)[1] <- colname
  row.names(y) <- NULL
  y
}
