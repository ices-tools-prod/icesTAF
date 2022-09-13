#' Install packages dependencies of a TAF analysis
#'
#' Search R scripts for packages that are required and install them.
#'
#' @param ... arguments passed on to \link{install.packages}
#'
#' @seealso
#'
#' \link{deps}
#'
#' @examples
#' \dontrun{
#'
#' library(icesTAF)
#'
#' # Download a TAF analysis
#' download("https://github.com/ices-taf/2019_san.sa.6/archive/refs/heads/master.zip")
#' unzip("master.zip")
#'
#' # move into analysis folder
#' setwd("2019_san.sa.6-master")
#'
#' # list dependencies
#' deps()
#'
#' # install dependencies
#' install.deps()
#' }
#'
#' @importFrom TAF deps
#' @importFrom utils install.packages
#'
#' @export
install.deps <- function(...) {
  install.packages(deps(installed = FALSE), ...)
}