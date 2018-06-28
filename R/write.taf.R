#' Write TAF Table to File
#'
#' Write a TAF table to a file.
#'
#' @param x a data frame in TAF format.
#' @param file a filename.
#' @param dir an optional directory name.
#' @param quote whether to quote strings.
#' @param row.names whether to include row names.
#' @param fileEncoding character encoding for output file.
#' @param \dots passed to \code{write.csv}.
#'
#' @details
#' Alternatively, \code{x} can be a string vector of names to write many tables
#' in one call, using \code{file = NULL} to automatically name the resulting
#' files.
#'
#' The default value \code{file = NULL} uses the name of \code{x} as a filename.
#' The special value \code{file = ""} prints the data frame in the console,
#' similar to \code{write.csv}.
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
#' write.taf(catage)
#' file.remove("catage.csv")
#' }
#'
#' @importFrom utils write.csv
#'
#' @export

write.taf <- function(x, file=NULL, dir=NULL, quote=FALSE, row.names=FALSE,
                      fileEncoding="UTF-8", ...)
{
  if(is.character(x) && length(x)>1)
    return(invisible(sapply(x, write.taf, file=NULL, dir=dir, quote=quote,
                            row.names=row.names, fileEncoding=fileEncoding,
                            ...)))
  if(is.character(x) && length(x)==1)
  {
    if(is.null(file))
      file <- paste0(x, ".csv")
    x <- get(x, envir=.GlobalEnv)
  }
  if(is.null(file))
    file <- paste0(deparse(substitute(x)), ".csv")
  if(!is.null(dir))
    file <- paste0(sub("[/\\]+$","",dir), "/", file)  # remove trailing slash
  write.csv(x, file=file, quote=quote, row.names=row.names,
            fileEncoding=fileEncoding, ...)
  if(file != "")
    unix2dos(file)
}
