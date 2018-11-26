#' Download File in Binary Mode
#'
#' Download a file in binary mode, e.g. a model executable.
#'
#' @param url URL of file to download.
#' @param dir directory to download to.
#' @param mode download mode, see details.
#' @param chmod whether to set execute permission (default is \code{TRUE} if
#'        file has no filename extension).
#' @param destfile destination path and filename (optional, overrides
#'        \code{dir}).
#' @param quiet whether to suppress messages.
#' @param \dots passed to \code{download.file}.
#'
#' @details
#' With the default mode \code{"wb"} the file is downloaded in binary mode (see
#' \code{\link{download.file}}), to prevent R from adding \verb{^M} at line
#' ends. This is particularly relevant for Windows model executables, while the
#' \code{chmod} switch is useful when downloading Linux executables.
#'
#' This function can be convenient for downloading any file, including text
#' files. Data files in CSV or other text format can also be read directly into
#' memory using \code{read.table}, \code{read.taf} or similar functions, without
#' writing to the file system.
#'
#' @seealso
#' \code{\link{read.taf}} reads a TAF table into a data frame.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' url <- paste0("https://github.com/ices-taf/2015_had-iceg/raw/master/",
#'               "bootstrap/initial/software/catageysa.exe")
#' download(url)
#' }
#'
#' @importFrom tools file_ext
#' @importFrom utils download.file
#'
#' @export

download <- function(url, dir=".", mode="wb", chmod=file_ext(url)=="",
                     destfile=file.path(dir,basename(url)), quiet=TRUE, ...)
{
  download.file(url=url, destfile=destfile, mode=mode, quiet=quiet, ...)
  if(chmod)
    Sys.chmod(destfile)
}
