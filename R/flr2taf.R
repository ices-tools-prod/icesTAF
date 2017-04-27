#' Convert FLR table to TAF format
#'
#' Convert a simple crosstab table from FLR format to TAF format.
#'
#' @param x a table of class \code{FLQuant}.
#' @param na a value that should be converted to NA.
#' @param year whether the year should be stored in the first column, instead of
#' row names.
#'
#' @note
#' FLR uses the \code{FLQuant} class to store tables as 6-dimensional arrays,
#' while TAF crosstabs are stored as data frames with a year column.
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
#' flr2taf(x, na=0, year=FALSE)
#'
#' @export

flr2taf <- function(x, na=NULL, year=TRUE)
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
