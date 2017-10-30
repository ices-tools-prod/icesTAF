#' Write TAF Table to File
#'
#' Write a TAF table to a file.
#'
#' @param x a data frame in TAF format.
#' @param file a filename.
#' @param quote whether to quote strings.
#' @param row.names whether to include row names.
#' @param fileEncoding character encoding for output file.
#' @param \dots passed to \code{write.csv}.
#'
#' @seealso
#' \code{\link{write.csv}} is the underlying function used to write a table to a
#' file.
#'
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

write.taf <- function(x, file="", quote=FALSE, row.names=FALSE,
                      fileEncoding="UTF-8", ...)
{
  write.csv(x, file=file, quote=quote, row.names=row.names,
            fileEncoding=fileEncoding, ...)
  if(file != "")
    unix2dos(file)
}
