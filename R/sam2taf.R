#' Convert SAM Table to TAF Format
#'
#' Convert a table from SAM format to TAF format.
#'
#' @param x a matrix containing columns \verb{Estimate}, \verb{Low}, and
#'        \verb{High}.
#' @param colname a descriptive column name for the output.
#' @param year whether to include a year column.
#'
#' @details
#' The default when \code{colname = NULL} is to try to infer a column name from
#' the \code{x} argument. For example,
#'
#' \preformatted{sam2taf(ssbtable(fit))
#' sam2taf(ssb)
#' sam2taf(SSB)}
#'
#' will recognize \verb{ssbtable} calls and \verb{ssb} object names, implicitly
#' setting \code{colname = "SSB"} if the user does not pass an explicit value
#' for \code{colname}.
#'
#' @return A data frame in TAF format.
#'
#' @note
#' The \pkg{stockassessment} package provides accessor functions that return a
#' matrix with columns \verb{Estimate}, \verb{Low}, and \verb{High}, while TAF
#' tables are stored as data frames with a year column.
#'
#' @seealso
#' \code{\link{summary.taf}} describes the TAF format.
#'
#' \code{catchtable}, \code{fbartable}, \code{rectable}, \code{ssbtable}, and
#' \code{tsbtable} (in the \pkg{stockassessment} package) return matrices with
#' SAM estimates and confidence limits.
#'
#' The \code{summary} method for \code{sam} objects produces a summary table
#' with some key quantities of interest, containing duplicated column names
#' (\verb{Low}, \verb{High}) and rounded values.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' ## Example objects
#' x <- as.matrix(summary.taf[grep("SSB", names(summary.taf))])
#' rec <- as.matrix(summary.taf[grep("Rec", names(summary.taf))])
#' tsb <- as.matrix(summary.taf[grep("TSB", names(summary.taf))])
#' dimnames(x) <- list(summary.taf$Year, c("Estimate", "Low", "High"))
#' dimnames(rec) <- dimnames(tsb) <- dimnames(x)
#'
#' ## One SAM table, arbitrary object name
#' sam2taf(x)
#' sam2taf(x, "SSB")
#' sam2taf(x, "SSB", year=FALSE)
#'
#' ## Many SAM tables, recognized names
#' sam2taf(rec)
#' data.frame(sam2taf(rec), sam2taf(tsb, year=FALSE))
#'
#' \dontrun{
#'
#' ## Accessing tables from SAM fit object
#' data.frame(sam2taf(rectable(fit)), sam2taf(tsbtable(fit), year=FALSE))
#' }
#'
#' @export

sam2taf <- function(x, colname=NULL, year=TRUE)
{
  y <- xtab2taf(x)
  if(is.null(colname))
    colname <- switch(tolower(as.character(substitute(x))[1]),
                      catch="Catch", catchtable="Catch",
                      fbar="Fbar", fbartable="Fbar",
                      rec="Rec", rectable="Rec",
                      ssb="SSB", ssbtable="SSB",
                      tsb="TSB", tsbtable="TSB",
                      "Estimate")
  names(y) <- c("Year", paste0(colname, c("", "_lo", "_hi")))
  if(!year)
    y$Year <- NULL
  y
}
