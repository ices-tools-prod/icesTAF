#' File Encoding
#'
#' Examine file encoding.
#'
#' @param file a filename.
#'
#' @return \code{"latin1"}, \code{"UTF-8"}, \code{"unknown"}, or \code{NA}.
#'
#' This function requires the \command{file} shell command. If the
#' \command{file} utility is not found in the path, this function looks for it
#' inside \verb{c:/Rtools/bin}. If the required software is not installed, this
#' function returns \code{NA}.
#'
#' @note
#' The encoding \code{"unknown"} indicates that the file is an ASCII text file
#' or a binary file.
#'
#' In TAF, text files that have non-ASCII characters should be encoded as UTF-8.
#'
#' If this function fails in Windows, the \code{guess_encoding} function in the
#' \pkg{readr} package may help.
#'
#' @seealso
#' \code{\link{Encoding}} examines the encoding of a string.
#'
#' \code{\link{latin1.to.utf8}} converts files from \verb{latin1} to
#' \verb{UTF-8} encoding.
#'
#' \code{\link{line.endings}} examines line endings.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' file.base <- system.file(package="base", "DESCRIPTION")
#' file.nlme <- system.file(package="nlme", "DESCRIPTION")
#' file.encoding(file.base)  # ASCII
#' file.encoding(file.nlme)
#' }
#'
#' @export

file.encoding <- function(file)
{
  if(!file.exists(file))
    stop("file not found")

  ## Examine file using the 'file' shell command
  info <- try(system(paste("file", shQuote(file)), intern=TRUE,
                     ignore.stderr=TRUE), silent=TRUE)

  ## If that didn't work, try Rtools
  if(class(info) == "try-error")
    info <- try(system(paste("c:/Rtools/bin/file", file), intern=TRUE,
                       ignore.stderr=TRUE), silent=TRUE)

  ## Return latin1, UTF-8, unknown, or NA
  out <- if(grepl(":.*ISO-8859",info)) "latin1"
         else if(grepl(":.*UTF-8",info)) "UTF-8"
         else if(class(info) == "try-error") NA_character_
         else "unknown"
  out
}
