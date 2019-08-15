#' Line Endings
#'
#' Examine whether file has Dos or Unix line endings.
#'
#' @param file a filename.
#'
#' @return String indicating the line endings: \code{"Dos"} or \code{"Unix"}.
#'
#' @seealso
#' \code{\link{file.encoding}} examines the encoding of a file.
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
  ## Read file as bytes
  bytes <- readBin(file, what="raw", n=1e4, endian="little")
  bytes <- paste(bytes, collapse=" ")

  ## Check if file contains CRLF (0d 0a)
  CRLF <- grepl("0d 0a", bytes)

  ## Return string
  out <- if(CRLF) "Dos" else "Unix"
  out
}
