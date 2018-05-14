#' Rename Plus Group Column
#'
#' Rename the last column in a data frame, by appending a \code{"+"} character.
#' This is useful if the last column is a plus group.
#'
#' @param x a data frame.
#'
#' @return A data frame similar to \code{x}, after renaming the last column.
#'
#' @seealso
#' \code{\link{names}} is the underlying function to rename columns.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' catage <- catage.taf
#'
#' # Rename last column
#' catage <- plus(catage)
#'
#' # Shorter and less error-prone than
#' names(catage)[names(catage)=="4"] <- "4+"
#'
#' @export

plus <- function(x)
{
  names(x)[ncol(x)] <- paste0(names(x)[ncol(x)], "+")
  x
}
