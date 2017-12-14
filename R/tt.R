#' TAF Transpose
#'
#' Convert a table from TAF format to transposed crosstab format.
#'
#' @param x a data frame in TAF format.
#' @param column a logical indicating whether the group names should be stored
#'        in a column called \samp{Age} instead of in row names. Alternatively,
#'        \code{column} can be a string supplying another name for that first
#'        column.
#'
#' @return A data frame with years as column names.
#'
#' @note
#' Transposing can be useful when comparing TAF tables to stock assessment
#' reports.
#'
#' @seealso
#' \code{\link{catage.taf}} describes the TAF format.
#'
#' \code{\link{taf2xtab}} converts a TAF table to crosstab format, without
#' transposing.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' taf2xtab(catage.taf)
#' tt(catage.taf)
#' tt(catage.taf, TRUE)
#' tt(catage.taf, "Custom")
#'
#' @export

tt <- function(x, column=FALSE)
{
  y <- as.data.frame(t(taf2xtab(x)))
  if(isTRUE(column))
    column <- "Age"
  if(is.character(column))
  {
    y <- data.frame(row.names(y), y, check.names=FALSE)
    names(y)[1] <- column
    row.names(y) <- NULL
  }
  y
}
