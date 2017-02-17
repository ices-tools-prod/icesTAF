#' Convert Line Endings
#'
#' Convert line endings in a text file between Dos (CRLF) and Unix (LF) format.
#'
#' @param file a filename.
#'
#' @note
#' TAF uses \code{unix2dos} to ensure that text files on the FTP server have Dos
#' line endings.
#'
#' @seealso
#' \code{\link{file}} is used to open a binary connection to the text file.
#'
#' \code{\link{writeLines}} is used to apply CRLF or LF line endings.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' write("123", "test.txt")
#' dos2unix("test.txt")  # file is now 4 bytes
#' unix2dos("test.txt")  # file is now 5 bytes
#' }
#'
#' @export

dos2unix <- function(file)
{
  txt <- readLines(file)
  con <- file(file, open="wb")
  writeLines(txt, con, sep="\n")
  close(con)
}
