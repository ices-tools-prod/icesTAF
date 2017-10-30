#' @docType data
#'
#' @name catage.taf
#'
#' @title Catch at Age in TAF Format
#'
#' @description
#' Small catch-at-age table to describe a TAF format data frame to store
#' year-age values.
#'
#' @usage
#' catage.taf
#'
#' @format
#' Data frame containing five columns:
#' \tabular{ll}{
#'   \code{Year} \tab year\cr
#'   \code{1}    \tab number of one-year-olds in the catch (millions)\cr
#'   \code{2}    \tab number of two-year-olds in the catch (millions)\cr
#'   \code{3}    \tab number of three-year-olds in the catch (millions)\cr
#'   \code{4}    \tab number of four-year-olds in the catch (millions)
#' }
#'
#' @details
#' The data are an excerpt (first years and ages) from the catch-at-age table
#' for North Sea cod from the ICES (2016) assessment.
#'
#' @source
#' ICES. 2016. Report of the working group on the assessment of demersal stocks
#' in the North Sea and Skagerrak (WGNSSK).
#' \href{http://ices.dk/sites/pub/Publication\%20Reports/Expert\%20Group\%20Report/acom/2016/WGNSSK/01\%20WGNSSK\%20report\%202016.pdf}{\cite{ICES
#' CM 2016/ACOM:14}}, p. 656.
#'
#' @seealso
#' \code{\link{catage.long}} and \code{\link{catage.xtab}} describe alternative
#' table formats.
#'
#' \code{\link{taf2long}} and \code{\link{taf2xtab}} convert a TAF table to
#' alternative formats.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#'
#' @examples
#' catage.taf
#' taf2long(catage.taf)
#' taf2xtab(catage.taf)

NA
