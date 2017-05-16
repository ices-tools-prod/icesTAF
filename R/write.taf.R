#' Write TAF Table to File
#'
#' Write a TAF table to a file.
#'
#' @param x a data frame in TAF format.
#' @param file a filename.
#'
#' @seealso
#' \code{\link{read.taf}} reads a TAF table from a file into a data frame.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' write.taf(catage.taf, "catage.csv")
#' catage <- read.taf("catage.csv")
#'
#' file.remove("catage.csv")
#' }
#'
#' @importFrom utils write.csv
#'
#' @export

write.taf <- function(x, file)
{
  write.csv(x, file, quote=FALSE, row.names=FALSE)
  unix2dos(file)
}
