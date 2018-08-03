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
#' @param underscore whether automatically generated filenames (when
#'        \code{file = NULL}) should use underscore separators instead of dots.
#' @param \dots passed to \code{write.csv}.
#'
#' @details
#' Alternatively, \code{x} can be a list of data frames or a string vector of
#' object names, to write many tables in one call. The resulting files are named
#' automatically, similar to \code{file = NULL}.
#'
#' The default value \code{file = NULL} uses the name of \code{x} as a filename,
#' so a data frame called \code{survey.uk} will be written to a file called
#' \file{survey_uk.csv} (when \code{underscore = TRUE}) or \file{survey.uk.csv}
#' (when \code{underscore = FALSE}).
#'
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
                      fileEncoding="UTF-8", underscore=TRUE, ...)
{
  ## 1  Handle many tables
  if(is.character(x) && length(x)>1)
    return(invisible(sapply(x, write.taf, file=NULL, dir=dir, quote=quote,
                            row.names=row.names, fileEncoding=fileEncoding,
                            underscore=underscore, ...)))
  if(is.list(x) && is.data.frame(x[[1]]))
  {
    file <- paste0(if(underscore) chartr(".","_",names(x))
                   else names(x), ".csv")
    dir <- if(is.null(dir)) "." else dir
    return(invisible(mapply(write.taf, x, file=file, dir=dir, quote=quote,
                            row.names=row.names, fileEncoding=fileEncoding,
                            underscore=underscore, ...)))
  }

  ## 2  Handle one table
  if(is.character(x) && length(x)==1)
  {
    if(is.null(file))
      file <- paste0(if(underscore) chartr(".","_",x) else x, ".csv")
    x <- get(x, envir=.GlobalEnv)
  }
  if(is.null(x))
    stop("x should be a data frame, not NULL")

  ## 3  Prepare file path
  if(is.null(file))
  {
    file <- deparse(substitute(x))
    file <- if(underscore) chartr(".","_",file) else file
    file <- sub(".*[@$]", "", file)  # parent@obj$data -> data
    file <- paste0(file, ".csv")
  }
  if(!is.null(dir))
    file <- paste0(sub("[/\\]+$","",dir), "/", file)  # remove trailing slash

  ## 4  Export
  write.csv(x, file=file, quote=quote, row.names=row.names,
            fileEncoding=fileEncoding, ...)
  if(file != "")
    unix2dos(file)
}
