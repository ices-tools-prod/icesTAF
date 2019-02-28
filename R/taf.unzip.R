#' Unzip File
#'
#' Extract files from a zip archive, retaining executable file permissions.
#'
#' @param zipfile zip archive filename.
#' @param files files to extract, default is all files.
#' @param exdir directory to extract to, will be created if necessary.
#' @param unzip extraction method to use, see details below.
#' @param \dots passed to \code{\link{unzip}}.
#'
#' @details
#' The default method \code{unzip = NULL} uses the external \command{unzip}
#' program in Unix-compatible operating systems, but an internal method in
#' Windows. For additional information, see the \code{\link{unzip}} help page.
#'
#' @note
#' One shortcoming of the base \code{unzip} function is that the default
#' \code{"internal"} method resets file permissions, so Linux and macOS
#' executables will return a \verb{'Permission denied'} error when run.
#'
#' This function is identical to the base \code{unzip} function, except the
#' default value \code{unzip = NULL} chooses an appropriate extraction method in
#' all operating systems, making it useful when writing platform-independent
#' scripts.
#'
#' @seealso
#' \code{\link{unzip}} is the base function to unzip files.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' exefile <- if(os.unix()) "run" else "run.exe"
#' taf.unzip("bootstrap/software/archive.zip", files=exefile, exdir="model")
#' }
#' @importFrom utils unzip
#'
#' @export

taf.unzip <- function(zipfile, files=NULL, exdir=".", unzip=NULL, ...)
{
  if(is.null(unzip))
    unzip <- if(os.windows()) "internal" else "unzip"
  unzip(zipfile=zipfile, files=files, exdir=exdir, unzip=unzip, ...)
}
