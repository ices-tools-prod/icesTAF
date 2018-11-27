#' Unzip File
#'
#' Extract files from a zip archive, retaining executable file permissions.
#'
#' @param zipfile zip archive filename.
#' @param files files to extract, default is all files.
#' @param exdir directory to extract to, will be created if necessary.
#' @param unzip extraction method to use.
#'
#' @details
#' The default method \code{unzip = NULL} uses the external \command{unzip}
#' program in Unix-compatible operating systems, but an internal method in
#' Windows. See \code{\link{unzip}} for additional information.
#'
#' @note
#' One shortcoming of the base \code{unzip} function is that the default
#' \code{"internal"} method resets file permissions, so Linux executables will
#' return a \samp{Permission denied} error when run.
#'
#' This function is identical to the base \code{unzip} function, except the
#' default value \code{unzip = NULL} chooses an appropriate extraction method on
#' all platforms, making it useful when writing platform-independent scripts.
#'
#' @seealso
#' \code{\link{unzip}} is the base function to unzip files.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' exefile <- if(taf.unix()) "run" else "run.exe"
#' taf.unzip("bootstrap/software/archive.zip", files=exefile, exdir="model")
#' }
#' @importFrom utils unzip
#'
#' @export

taf.unzip <- function(zipfile, files=NULL, exdir=".", unzip=NULL, ...)
{
  if(is.null(unzip))
    unzip <- if(.Platform$OS.type == "unix") "unzip" else "internal"
  unzip(zipfile=zipfile, files=files, exdir=exdir, unzip=unzip, ...)
}
