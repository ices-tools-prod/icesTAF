#' Convert TAF Table to Long Format
#'
#' Convert a table from TAF to long format.
#'
#' @param x a data frame in TAF format.
#' @param names a vector of three column names for the resulting data frame.
#'
#' @return
#' A data frame with three columns.
#'
#' @note
#' TAF stores tables as data frames with a year column, as seen in stock
#' assessment reports. The long format is more convenient for analysis and
#' producing plots.
#'
#' @seealso
#' \code{\link{flr2taf}} converts FLR tables to TAF format.
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
  y[[1]] <- as.integer(as.character(y[[1]]))
  y[[2]] <- as.integer(as.character(y[[2]]))
  names(y) <- names
  y
}
