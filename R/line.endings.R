#' Line Endings
#'
#' Examine whether file has Dos or Unix line endings.
#'
#' @param file filename of a text file, e.g. source code or data.
#'
#' @return
#' String indicating the line endings: \code{"Dos"}, \code{"Unix"}, or
#' \code{NA}.
#'
#' @seealso
#' \code{\link{enc}} examines the encoding of a file.
#'
#' \code{\link{dos2unix}} and \code{\link{unix2dos}} convert line endings.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' file <- system.file(package="icesTAF", "DESCRIPTION")
#' line.endings(file)
#' }
#'
#' @export

line.endings <- function(file)
{
  ## Examine file using the 'file' shell command
  info <- try(system(paste("file", file), intern=TRUE,
                     ignore.stderr=TRUE), silent=TRUE)

  ## If that didn't work, try Rtools
  if(class(info) == "try-error")
    info <- try(system(paste("c:/Rtools/bin/file", file), intern=TRUE,
                       ignore.stderr=TRUE), silent=TRUE)

  ## Remember original line endings
  out <- if(grepl(":.*CRLF",info)) "Dos"
         else if(class(info) == "try-error") "Unknown"
         else "Unix"
  out
}
