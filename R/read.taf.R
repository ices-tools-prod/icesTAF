#' Read TAF Table from File
#'
#' Read a TAF table from a file into a data frame.
#'
#' @param file a filename.
#'
#' @return
#' A data frame in TAF format.
#'
#' @seealso
#' \code{\link{write.taf}} writes a TAF table to a file.
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
#' @importFrom utils read.csv
#'
#' @export

read.taf <- function(file)
{
  read.csv(file, check.names=FALSE)
}
