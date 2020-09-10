#' Construct Path to a TAF bootstrap folder
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
#' the boot (bootstrap) folder.
#'
#' @return character
#' @export
taf.boot.path <- function(..., fsep = .Platform$file.sep) {
  if (basename(dirname(dirname(getwd()))) == "bootstrap") {
    args <- list("..")
  } else {
    args <- list("bootstrap")
  }
  do.call(file.path, c(args, ..., fsep = fsep))
}
