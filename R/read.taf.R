#' Read TAF Table from File
#'
#' Read a TAF table from a file into a data frame.
#'
#' @param file a filename.
#' @param check.names whether to enforce regular column names, e.g. convert
#'        column name \samp{3} to \samp{X3}.
#' @param fileEncoding character encoding of input file.
#' @param \dots passed to \code{read.csv}.
#'
#' @return
#' A data frame in TAF format, or a list of data frames if \code{file} is a
#' vector of filenames.
#'
#' @seealso
#' \code{\link{read.csv}} is the underlying function used to read a table from a
#' file.
#'
#' \code{\link{write.taf}} writes a TAF table to a file.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' write.taf(catage.taf, "catage.csv")
#' catage <- read.taf("catage.csv")
#'
#' write.taf(catage)
#' file.remove("catage.csv")
#' }
#'
#' @importFrom tools file_path_sans_ext
#' @importFrom utils read.csv
#'
#' @export

read.taf <- function(file, check.names=FALSE, fileEncoding="UTF-8", ...)
{
  if(length(file) > 1)
  {
    out <- lapply(file, read.taf, check.names=check.names,
                  fileEncoding=fileEncoding, ...)
    names(out) <- basename(file_path_sans_ext(file))
    out
  }
  else
  {
    read.csv(file, check.names=check.names, fileEncoding=fileEncoding, ...)
  }
}
