#' Convert Line Endings
#'
#' Convert line endings in a text file between Dos (CRLF) and Unix (LF) format.
#'
#' @param file a filename.
#'
#' @seealso
#' \code{\link{file}} is used to open a binary connection to the text file.
#'
#' \code{\link{writeLines}} is used to apply CRLF or LF line endings.
#'
#' \code{\link{write.taf}} uses \code{unix2dos} to ensure that the resulting
#' files have Dos line endings.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' file <- "test.txt"
#' write("123", file)
#'
#' dos2unix(file)
#' file.size(file)
#'
#' unix2dos(file)
#' file.size(file)
#'
#' file.remove(file)
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
