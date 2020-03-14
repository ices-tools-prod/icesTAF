#' Convert Long Table to Crosstab Format
#'
#' Convert a table from long format to crosstab format.
#'
#' @param x a data frame in long format.
#'
#' @return A data frame with years as row names.
#'
#' @seealso
#' \code{\link{catage.long}} and \code{\link{catage.xtab}} describe the long and
#' crosstab formats.
#'
#' \code{\link{long2taf}} and \code{\link{taf2xtab}} are the underlying
#' functions that perform the conversion.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' long2xtab(catage.long)
#'
#' @export

long2xtab <- function(x)
{
  taf2xtab(long2taf(x))
}
