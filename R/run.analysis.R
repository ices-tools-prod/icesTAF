#' Run a TAF analysis
#'
#' Run the code for a TAF analysis locally.
#'
#' @param dir the directory where the TAF project is located
#'
#' @seealso
#'
#' \link{download.analysis}
#'
#' @examples
#' \dontrun{
#'
#' library(icesTAF)
#'
#' # Download a TAF analysis
#' run_dir <- download.analysis("ices-taf/2019_san.sa.6", dir = ".")
#'
#' # run the analysis
#' run.analysis(run_dir)
#' }
#'
#' @importFrom TAF taf.bootstrap sourceAll
#'
#' @export

run.analysis <- function(dir) {
  # install packages
  install.deps(dir)
  # run
  oldwd <- setwd(dir)
  taf.bootstrap()
  sourceAll()
  setwd(oldwd)

  message("Taf analysis in directory: ", dir, " has been run.")
  invisible()
}
