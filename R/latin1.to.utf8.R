#' Convert File Encoding
#'
#' Convert file encoding between \verb{"latin1"} and \verb{"UTF-8"}.
#'
#' @param file a filename.
#' @param force whether to perform the conversion even if the current file
#'        encoding cannot be verified with \code{\link{file.encoding}}. Not
#'        recommended.
#'
#' @note
#' In TAF, text files that have non-ASCII characters must be encoded as UTF-8.
#'
#' @seealso
#' \code{\link{iconv}} converts the encoding of a string.
#'
#' \code{\link{file.encoding}} examines the encoding of a file.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' utf8.to.latin1("data.txt")
#' latin1.to.utf8("data.txt")
#' }
#'
#' @export

latin1.to.utf8 <- function(file, force=FALSE)
{
  if(!isTRUE(file.encoding(file)=="latin1") && !force)
  {
    warning("could not verify that file is 'latin1' encoded, nothing done")
    return(invisible(NULL))
  }

  ## Remember original line endings
  ole <- line.endings(file)

  ## Convert file encoding latin1 -> UTF-8
  txt <- readLines(file, encoding="latin1")
  txt <- iconv(txt, from="latin1", to="UTF-8")
  writeLines(txt, file, useBytes=TRUE)

  ## Retain original line endings
  switch(ole, Dos=unix2dos(file), Unix=dos2unix(file))
}
