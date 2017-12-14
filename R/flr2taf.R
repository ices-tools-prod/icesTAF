#' Convert FLR Table to TAF Format
#'
#' Convert a table from FLR format to TAF format.
#'
#' @param x a table of class \code{FLQuant}.
#'
#' @return A data frame in TAF format.
#'
#' @note
#' FLR uses the \code{FLQuant} class to store tables as 6-dimensional arrays,
#' while TAF tables are stored as data frames with a year column.
#'
#' @seealso
#' \code{\link{catage.taf}} describes the TAF format.
#'
#' \code{\link{as.data.frame}} is a method provided by the \pkg{FLCore} package
#' to convert \code{FLQuant} tables to a 7-column long format.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' x <- array(t(catage.xtab), dim=c(4,8,1,1,1,1))
#' dimnames(x) <- list(age=1:4, year=1963:1970,
#'                     unit="unique", season="all", area="unique", iter=1)
#' flr2taf(x)
#'
#' @export

flr2taf <- function(x)
{
  xtab2taf(as.data.frame(t(drop(unclass(x)))))
}
