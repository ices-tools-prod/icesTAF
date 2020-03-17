#' Convert TAF Table to Long Format
#'
#' Convert a table from TAF format to long format.
#'
#' @param x a data frame in TAF format.
#' @param names a vector of three column names for the resulting data frame.
#'
#' @return A data frame with three columns.
#'
#' @note
#' TAF stores tables as data frames, usually with a year column as seen in stock
#' assessment reports. The long format is more convenient for analysis and
#' producing plots.
#'
#' @seealso
#' \code{\link{catage.taf}} and \code{\link{catage.long}} describe the TAF and
#' long formats.
#'
#' \code{\link{long2taf}} converts a long table to TAF format.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' taf2long(catage.taf, names=c("Year","Age","Catch"))
#'
#' @importFrom utils type.convert
#'
#' @export

taf2long <- function(x, names=c("Year","Age","Value"))
{
  row.names(x) <- x[[1]]
  x <- x[-1]
  y <- as.data.frame(as.table(as.matrix(x)))
  y[[1]] <- type.convert(as.character(y[[1]]), as.is=TRUE)
  y[[2]] <- type.convert(as.character(y[[2]]), as.is=TRUE)
  names(y) <- names
  y
}
