#' File Encoding
#'
#' Examine file encoding.
#'
#' @param file filename of a text file, e.g. source code or data.
#'
#' @return
#' \code{enc} returns \code{"latin1"}, \code{"UTF-8"}, or \code{"unknown"}.
#'
#' \code{enc.latin1}, \code{enc.unknown}, and \code{enc.utf8} return \code{TRUE}
#' or \code{FALSE}.
#'
#' These functions require the \command{file} shell command. If the
#' \command{file} utility is not found in the path, this function looks for it
#' inside \file{c:/Rtools/bin}. If the required software is not installed, all
#' the above functions return \code{NA}.
#'
#' \code{enc.na} returns \code{TRUE} or \code{FALSE}, indicating whether file
#' encodings are not available because of missing software.
#'
#' @note
#' The encoding \code{"unknown"} refers to an ASCII text file or a binary file.
#'
#' When examining a given file, only one of the \verb{enc.*} test functions will
#' return \code{TRUE}, while the others return \code{FALSE} or \code{NA}.
#'
#' In TAF, all text files that have non-ASCII characters are required to be
#' encoded as \code{"UTF-8"}, not \code{"latin1"}.
#'
#' @seealso
#' \code{\link{Encoding}} examines the encoding of a string.
#'
#' \code{\link{latin1.to.utf8}} converts files from \verb{latin1} to
#' \verb{UTF-8} encoding.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' file <- system.file(package="nlme", "DESCRIPTION")
#' enc(file)
#' enc.latin1(file)
#' enc.na(file)
#' enc.unknown(file)
#' enc.utf8(file)
#' }
#'
#' @export

enc <- function(file)
{
  if(!file.exists(file))
    stop("file not found")

  ## Examine file using the 'file' shell command
  info <- try(system(paste("file", file), intern=TRUE,
                     ignore.stderr=TRUE), silent=TRUE)

  ## If that didn't work, try Rtools
  if(class(info) == "try-error")
    info <- try(system(paste("c:/Rtools/bin/file", file), intern=TRUE,
                       ignore.stderr=TRUE), silent=TRUE)

  ## Return latin1, UTF-8, unknown, or NA
  out <- if(grepl("ISO-8859",info)) "latin1"
         else if(grepl("UTF-8",info)) "UTF-8"
         else if(class(info) == "try-error") NA_character_
         else "unknown"
  out
}

#' @rdname enc
#'
#' @export

enc.latin1 <- function(file)
{
  if(is.na(enc(file)))
    NA
  else
    enc(file) == "latin1"
}

#' @rdname enc
#'
#' @export

enc.na <- function(file)
{
  is.na(enc(file))
}

#' @rdname enc
#'
#' @export

enc.unknown <- function(file)
{
  if(is.na(enc(file)))
    NA
  else
    enc(file) == "unknown"
}

#' @rdname enc
#'
#' @export

enc.utf8 <- function(file)
{
  if(is.na(enc(file)))
    NA
  else
    enc(file) == "UTF-8"
}
