#' @docType data
#'
#' @name catage.xtab
#'
#' @title Catch at Age in Crosstab Format
#'
#' @description
#' Small catch-at-age table to describe a crosstab format data frame to store
#' year-age values.
#'
#' @usage
#' catage.xtab
#'
#' @format
#' Data frame with years as row names and containing four columns:
#' \tabular{ll}{
#'   \code{1} \tab number of one-year-olds in the catch (millions)\cr
#'   \code{2} \tab number of two-year-olds in the catch (millions)\cr
#'   \code{3} \tab number of three-year-olds in the catch (millions)\cr
#'   \code{4} \tab number of four-year-olds in the catch (millions)
#' }
#'
#' @details
#' The data are an excerpt (first years and ages) from the catch-at-age table
#' for North Sea cod from the ICES (2016) assessment.
#'
#' @source
#' ICES (2016) Report of the working group on the assessment of demersal stocks
#' in the North Sea and Skagerrak (WGNSSK).
#' \href{http://ices.dk/sites/pub/Publication\%20Reports/Expert\%20Group\%20Report/acom/2016/WGNSSK/01\%20WGNSSK\%20report\%202016.pdf}{\emph{ICES
#' CM 2016/ACOM:14}}, p. 656.
#'
#' @seealso
#' \code{\link{catage.long}} and \code{\link{catage.taf}} describe alternative
#' table formats.
#'
#' \code{\link{xtab2taf}} converts a crosstab table to TAF format.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#'
#' @examples
#' catage.xtab
#' xtab2taf(catage.xtab)

NA
