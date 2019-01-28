#' Read TAF Table from File
#'
#' Read a TAF table from a file into a data frame.
#'
#' @param file a filename.
#' @param check.names whether to enforce regular column names, e.g. convert
#'        column name \samp{"3"} to \samp{"X3"}.
#' @param stringsAsFactors whether to import strings as factors.
#' @param fileEncoding character encoding of input file.
#' @param \dots passed to \code{read.csv}.
#'
#' @details
#' Alternatively, \code{file} can be a directory or a vector of filenames, to
#' read many tables in one call.
#'
#' @return
#' A data frame in TAF format, or a list of data frames if \code{file} is a
#' directory or a vector of filenames.
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

read.taf <- function(file, check.names=FALSE, stringsAsFactors=FALSE,
                     fileEncoding="UTF-8", ...)
{
  ## Ensure file is either single dirname or only filenames
  if(any(dir.exists(file)) && length(file)>1)
    stop("'file' must be of length 1 when it is a directory name")
  if(dir.exists(file))
  {
    file <- dir(file, pattern="\\.csv$", full.names=TRUE)
    ## Ensure file is not a dirname without CSV files
    if(length(file) == 0)
      stop("directory contains no CSV files")
  }

  ## Now ready to import one or more CSV files
  if(length(file) > 1)
  {
    out <- lapply(file, read.taf, check.names=check.names,
                  stringsAsFactors=stringsAsFactors,
                  fileEncoding=fileEncoding, ...)
    names(out) <- basename(file_path_sans_ext(file))
    out
  }
  else
  {
    read.csv(file, check.names=check.names, stringsAsFactors=stringsAsFactors,
             fileEncoding=fileEncoding, ...)
  }
}
