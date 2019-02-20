#' Convert Latin 1 to UTF-8
#'
#' Convert file encoding from \verb{"latin1"} to \verb{"UTF-8"}.
#'
#' @param file filename of a text file, e.g. source code or data.
#' @param force whether to perform the conversion even when it's not clear that
#'        the file is currently \code{"latin1"} encoded. Not recommended.
#'
#' @details
#' This function should only be used on a file that is currently \code{"latin1"}
#' encoded. The default behavior is to verify this with
#' \code{\link{enc.latin1}}, but this check can be suppressed using
#' \code{force = TRUE}.
#'
#' @note
#' For robust and efficient batch conversion of multiple files, the
#' \command{iconv} shell command is more appropriate.
#'
#' @seealso
#' \code{\link{Encoding}} examines the encoding of a string.
#'
#' \code{\link{enc}} examines the encoding of a file.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' latin1.to.utf8("data.txt")
#' }
#'
#' @export

latin1.to.utf8 <- function(file, force=FALSE)
{
  if(!force && !isTRUE(enc.latin1(file)))
  {
    warning("could not verify that file is 'latin1' encoded, nothing done")
    return(invisible(NULL))
  }

  ## Remember original line endings
  ole <- line.endings(file)

  ## Convert file encoding latin1 -> UTF-8
  txt <- readLines(file, encoding="latin1")
  txt <- iconv(txt, to="UTF-8")
  writeLines(txt, file, useBytes=TRUE)

  ## Retain original line endings
  switch(ole, Dos=unix2dos(file), Unix=dos2unix(file))
}
