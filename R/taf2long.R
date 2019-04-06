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
#' \code{\link{catage.long}} and \code{\link{catage.taf}} describe the long and
#' TAF formats.
#'
#' \code{\link{long2taf}} converts a long table to TAF format.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' taf2long(catage.taf, names=c("Year","Age","Catch"))
#'
#' @export

taf2long <- function(x, names=c("Year","Age","Value"))
{
  row.names(x) <- x[[1]]
  x <- x[-1]
  y <- as.data.frame(as.table(as.matrix(x)))
  y[[1]] <- simplify(y[[1]])
  y[[2]] <- simplify(y[[2]])
  names(y) <- names
  y
}
