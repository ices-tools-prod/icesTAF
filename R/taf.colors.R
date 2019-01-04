#' @docType data
#'
#' @name taf.colors
#'
#' @aliases taf.green taf.orange taf.blue taf.dark taf.light
#'
#' @title TAF Colors
#'
#' @description Predefined colors for TAF plots.
#'
#' @usage
#' taf.green
#' taf.orange
#' taf.blue
#' taf.dark
#' taf.light
#'
#' @seealso
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' taf.green
#'
#' par(mfrow=c(3,1))
#'
#' barplot(5:1, main="Five",
#'         col=c(taf.green, taf.orange, taf.blue, taf.dark, taf.light))
#'
#' barplot(6:1, main="Six", col=c(taf.green, taf.orange, taf.blue,
#'                                taf.dark, taf.light, "white"))
#'
#' barplot(7:1, main="Seven", col=c("black", taf.dark, taf.light,
#'                                  taf.green, taf.orange, taf.blue, "white"))

NA
