#' Download File
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
#' @note
#' If \code{destfile} contains a question mark it is removed from the
#' \code{destfile} filename. Similarly, if \code{destfile} contains spaces or
#' \file{\%20} sequences, those are converted to underscores.
#'
#' In general, TAF scripts do not access the internet using
#' \code{download} or similar functions. Instead, data and software are declared
#' in DATA.bib and SOFTWARE.bib and then downloaded using
#' \code{\link{taf.bootstrap}}. The exception is when a bootstrap script is used
#' to fetch files from a web service (see
#' \href{https://github.com/ices-taf/doc/wiki/Bib-entries}{TAF Wiki}).
#'
#' @seealso
#' \code{\link{download.file}} is the underlying base function to download
#' files.
#'
#' \code{\link{download.github}} downloads a GitHub repository.
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
  destfile <- gsub("\\?.*", "", destfile)   # file.dat?tail -> file.dat
  download.file(url=url, destfile=destfile, mode=mode, quiet=quiet, ...)
  convert.spaces(destfile)  # my%20script.R -> my_script.R
  if(chmod)
    Sys.chmod(destfile)
}
