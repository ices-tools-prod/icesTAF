#' Convert FLR Table to TAF Format
#'
#' Convert a table from FLR to TAF format.
#'
#' @param x a table of class \code{FLQuant}.
#' @param year whether the year should be stored in the first column, instead of
#' row names.
#' @param na a value that should be converted to NA.
#'
#' @return
#' A data frame in TAF format.
#'
#' @note
#' FLR uses the \code{FLQuant} class to store tables as 6-dimensional arrays,
#' while TAF tables are stored as data frames with a year column.
#'
#' @seealso
#' \code{\link{as.data.frame}} is a method provided by the \pkg{FLCore} package
#' to convert \code{FLQuant} tables to a 7-column long format.
#'
#' \code{\link{taf2long}} converts TAF tables to long format.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' x <- array(round(runif(70)/3, 1), dim=c(7,10,1,1,1,1))
#' dimnames(x) <- list(age=2:8, year=1991:2000,
#'                     unit="unique", season="all", area="unique", iter=1)
#' flr2taf(x)
#' flr2taf(x, year=FALSE, na=0)
#'
#' @export

flr2taf <- function(x, year=TRUE, na=NULL)
{
  y <- as.data.frame(t(drop(unclass(x))))
  if(year)
  {
    y <- cbind(Year=as.integer(row.names(y)), y)
    row.names(y) <- NULL
  }
  if(!is.null(na))
  {
    y[y==na] <- NA
  }
  y
}
