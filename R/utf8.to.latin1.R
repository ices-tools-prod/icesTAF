#' @rdname latin1.to.utf8
#'
#' @export

utf8.to.latin1 <- function(file, force=FALSE)
{
  if(!isTRUE(file.encoding(file)=="UTF-8") && !force)
  {
    warning("could not verify that file is 'UTF-8' encoded, nothing done")
    return(invisible(NULL))
  }

  ## Remember original line endings
  ole <- line.endings(file)

  ## Convert file encoding UTF-8 -> latin1
  txt <- readLines(file, encoding="UTF-8")
  txt <- iconv(txt, from="UTF-8", to="latin1")
  writeLines(txt, file, useBytes=TRUE)

  ## Retain original line endings
  switch(ole, Dos=unix2dos(file), Unix=dos2unix(file))
}
