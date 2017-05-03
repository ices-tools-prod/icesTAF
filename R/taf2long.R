#' Convert TAF Table to Long Format
#'
#' Convert a table from TAF to long format.
#'
#' @param x a data frame in TAF format.
#' @param names a vector of three column names for the resulting data frame.
#' @param year whether the input table has year in the first column, instead of
#' row names.
#'
#' @return
#' A data frame with three columns.
#'
#' @note
#' TAF stores tables as data frames with a year column, as seen in stock
#' assessment reports. The long format is practical for analysis and producing
#' plots.
#'
#' @seealso
#' \code{\link{flr2taf}} converts FLR tables to TAF format.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' fish <- matrix(round(runif(30),3), 5)
#' fish <- data.frame(Year=2001:2005, fish, check.names=FALSE)
#' taf2long(fish)
#'
#' alt <- fish[-1]
#' row.names(alt) <- fish$Year
#' taf2long(alt, names=c("Year","Age","Weight"), year=FALSE)
#'
#' @export

taf2long <- function(x, names=c("Year","Age","Value"), year=TRUE)
{
  if(year)
  {
    row.names(x) <- x[[1]]
    x <- x[-1]
  }
  y <- as.data.frame(as.table(as.matrix(x)))
  names(y) <- names
  y
}
