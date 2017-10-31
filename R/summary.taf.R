#' @docType data
#'
#' @name summary.taf
#'
#' @title Summary Results in TAF Format
#'
#' @description
#' Small summary results table to describe a TAF format data frame to store
#' values by year.
#'
#' @usage
#' summary.taf
#'
#' @format
#' Data frame containing 16 columns:
#' \tabular{ll}{
#'   \code{Year}        \tab year\cr
#'   \code{Rec}         \tab recruitment, numbers at age 1 in this year
#'                           (thousands)\cr
#'   \code{Rec_lo}      \tab lower 95\% confidence limit\cr
#'   \code{Rec_hi}      \tab upper 95\% confidence limit\cr
#'   \code{TSB}         \tab total stock biomass (tonnes)\cr
#'   \code{TSB_lo}      \tab lower 95\% confidence limit\cr
#'   \code{TSB_hi}      \tab upper 95\% confidence limit\cr
#'   \code{SSB}         \tab spawning stock biomass (tonnes)\cr
#'   \code{SSB_lo}      \tab lower 95\% confidence limit\cr
#'   \code{SSB_hi}      \tab upper 95\% confidence limit\cr
#'   \code{Removals}    \tab total removals, including catches due to
#'                           unaccounted mortality\cr
#'   \code{Removals_lo} \tab lower 95\% confidence limit\cr
#'   \code{Removals_hi} \tab upper 95\% confidence limit\cr
#'   \code{Fbar}        \tab average fishing mortality (ages 2-4)\cr
#'   \code{Fbar_lo}     \tab lower 95\% confidence limit\cr
#'   \code{Fbar_hi}     \tab upper 95\% confidence limit
#' }
#'
#' @details
#' The data are an excerpt (first years) from the summary results table for
#' North Sea cod from the ICES (2016) assessment.
#'
#' @source
#' ICES. 2016. Report of the working group on the assessment of demersal stocks
#' in the North Sea and Skagerrak (WGNSSK).
#' \href{http://ices.dk/sites/pub/Publication\%20Reports/Expert\%20Group\%20Report/acom/2016/WGNSSK/01\%20WGNSSK\%20report\%202016.pdf}{\cite{ICES
#' CM 2016/ACOM:14}}, p. 673.
#'
#' @seealso
#' \code{\link{div}} and \code{\link{rnd}} can modify a large number of columns.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' summary.taf
#' x <- div(summary.taf, "Rec|TSB|SSB|Removals", grep=TRUE)
#' x <- rnd(x, "Rec|TSB|SSB|Removals", grep=TRUE)
#' x <- rnd(x, "Fbar", 3, grep=TRUE)

NA
