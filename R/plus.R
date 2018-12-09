#' Rename Plus Group Column
#'
#' Rename the last column in a data frame, by appending a \code{"+"} character.
#' This is useful if the last column is a plus group.
#'
#' @param x a data frame.
#'
#' @return A data frame similar to \code{x}, after renaming the last column.
#'
#' @note
#' If the last column name already ends with a \code{"+"}, the original data
#' frame is returned without modifications.
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
  lastname <- names(x)[ncol(x)]
  lastchar <- substring(lastname, nchar(lastname))
  if(lastchar != "+")
    names(x)[ncol(x)] <- paste0(lastname, "+")
  x
}
