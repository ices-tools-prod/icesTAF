#' Convert Long Table to TAF Format
#'
#' Convert a table from long format to TAF format.
#'
#' @param x a data frame in long format.
#'
#' @return A data frame in TAF format.
#'
#' @note
#' TAF stores tables as data frames with a year column, as seen in stock
#' assessment reports. The long format is more convenient for analysis and
#' producing plots.
#'
#' @seealso
#' \code{\link{catage.long}} and \code{\link{catage.taf}} describe the long and
#' TAF formats.
#'
#' \code{\link{taf2long}} converts a TAF table to long format.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' long2taf(catage.long)
#'
#' @importFrom stats xtabs
#'
#' @export

long2taf <- function(x)
{
  y <- xtabs(x[[3]]~x[[1]]+x[[2]])
  xtab2taf(y)
}
