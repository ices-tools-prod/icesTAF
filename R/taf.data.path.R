#' Construct Path to a TAF bootstrap data file
#'
#' Construct the path to a file in the TAF bootstrap data folder
#' from components in a platform-independent way.  This function
#' checks to see if R is running in the bootstrap folder - i.e.
#' `taf.bootstrap()` is running, and adjusts the path accordingly.
#'
#' @param ... character vectors. Long vectors are not supported.
#' @param fsep the path separator to use (assumed to be ASCII).
#'
#' @seealso \link{file.path}
#' @details
#' This function, simplifies the construction of file paths to
#' inintial data files gathered during the TAF bootstrapping step.
#' In addition, this function is useful when developing scripts used
#' in the bootstrap procedure, as these scripts are run with the
#' working directory set to the bootstrap folder, and hence make it
#' to develop and debug.
#'
#' @return character
#' @export
taf.data.path <- function(..., fsep = .Platform$file.sep) {
  taf.boot.path("data", ...)
}
