#' @docType data
#'
#' @name catage.long
#'
#' @title Catch at Age in Long Format
#'
#' @description
#' Small catch-at-age table to describe a long format data frame to store
#' year-age values.
#'
#' @usage
#' catage.long
#'
#' @format
#' Data frame containing three columns:
#' \tabular{ll}{
#'   \code{Year}  \tab year\cr
#'   \code{Age}   \tab age\cr
#'   \code{Catch} \tab catch (millions of individuals)
#' }
#'
#' @details
#' The data are an excerpt (first years and ages) from the catch-at-age table
#' for North Sea cod from the ICES (2016) assessment.
#'
#' @source
#' ICES (2016) Report of the working group on the assessment of demersal stocks
#' in the North Sea and Skagerrak (WGNSSK).
#' \href{https://doi.org/10.17895/ices.pub.5329}{\emph{ICES CM 2016/ACOM:14}},
#' p. 673.
#'
#' @seealso
#' \code{\link{catage.taf}} and \code{\link{catage.xtab}} describe alternative
#' table formats.
#'
#' \code{\link{long2taf}} converts a long table to TAF format.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' catage.long
#' long2taf(catage.long)

NA
