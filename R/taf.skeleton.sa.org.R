#' TAF Skeleton
#'
#' Create initial directories and R scripts for a new TAF analysis using
#' a stock assessment created on stockassessment.org.
#'
#' @param path where to create initial directories and R scripts. The default is
#'        the current working directory.
#' @param stockname The short-form name of a stock on stockassessment.org.
#' @param force whether to overwrite existing scripts.
#'
#' @return Full path to analysis directory.
#'
#' @seealso
#' \code{\link{package.skeleton}} creates an empty template for a new R package.
#'
#' \code{\link{TAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' taf.skeleton.sa.org(stockname = "WBCod_2021_cand01")
#' }
#'
#' @importFrom TAF draft.data taf.skeleton
#' @export

taf.skeleton.sa.org <- function(path = ".", stockname, force = FALSE) {
  taf.skeleton(path)
  owd <- setwd(path)
  on.exit(setwd(owd))

  cat(paste0('library(stockassessment)

# download model from stockassessment.org
fit <- fitfromweb("', stockname, '")

# save to model folder
save(fit, file = "fit.rData")

'),
    file = "bootstrap/sam_fit.R"
  )

  cat(paste0('sam_assessment <- "', stockname, '"

sam_dir <-
  paste0(
    "https://stockassessment.org/datadisk/stockassessment/userdirs/user3/",
    sam_assessment,
    "/data/"
  )

files <-
  paste0(
    c("cn", "cw", "dw", "lf", "lw", "mo", "nm", "pf", "pm", "survey", "sw"),
    ".dat"
  )

for (file in files) {
  download(paste0(sam_dir, file))
}

'),
    file = "bootstrap/sam_data.R"
  )

  draft.data(
    data.files = NULL,
    data.scripts = c("sam_data", "sam_fit"),
    originator = "",
    title = c("SAM input data for ...", "SAM fitted object for ..."),
    file = TRUE,
    append = TRUE
  )

  message(
    "To run this template please ensure you have the package:\n",
    "\tstockasessment\n",
    "by running:\n",
    '\tinstall.packages("stockassessment", repos = "https://fishfollower.r-universe.dev")'
  )

  invisible(path)
}
