#' Convert Crosstab Table to Long Format
#'
#' Convert a table from crosstab format to long format.
#'
#' @param x a data frame in crosstab format.
#' @param names a vector of three column names for the resulting data frame.
#'
#' @return A data frame with three columns.
#'
#' @seealso
#' \code{\link{catage.xtab}} and \code{\link{catage.long}} describe the crosstab
#' and long formats.
#'
#' \code{\link{xtab2taf}} and \code{\link{taf2long}} are the underlying
#' functions that perform the conversion.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' xtab2long(catage.xtab, names=c("Year","Age","Catch"))
#'
#' @export

xtab2long <- function(x, names=c("Year","Age","Value"))
{
  taf2long(xtab2taf(x), names=names)
}
