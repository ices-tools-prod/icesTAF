#' TAF Skeleton
#'
#' Create an empty template for a new TAF analysis: initial directories and R
#' scripts with TAF header comments.
#'
#' @param name main directory name for the analysis.
#' @param path path to create the analysis directory in.
#' @param force whether to overwrite an existing directory.
#'
#' @details
#' Use \code{name = "."} to create initial directories and scripts inside the
#' current working directory.
#'
#' @return
#' Full path to analysis directory.
#'
#' @seealso
#' \code{\link{package.skeleton}} creates an empty template for a new R package.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' taf.skeleton()
#' }
#'
#' @export

taf.skeleton <- function(name = "analysis", path = ".", force = FALSE)
{
  # only overwrite files if force = TRUE
  safe.cat <- function(..., file = "", force = FALSE) {
    if (!file.exists(file) || force) {
      cat(..., file = file)
    }
  }

  # create analysis directory
  mkdir(paste0(path, "/", name))
  owd <- setwd(paste0(path, "/", name))
  on.exit(setwd(owd))

  # create initial directories
  mkdir("_raw")
  mkdir("_model")

  # define headers
  template <- "## %s\n\n## Before:\n## After:\n\n"
  headers <- list(
    `_model` = "Upload model executables to TAF database",
    `_raw` = "Upload raw data to TAF database",
    data = "Preprocess data, write TAF data tables",
    input = "Convert data to model format, write model input files",
    model = "Run analysis, write model results",
    output = "Extract results of interest, write TAF output tables",
    report = "Prepare plots/tables for report")

  # create TAF scripts
  for (section in names(headers)) {
    if (section %in% c("_model", "_raw")) {
      safe.cat(file = file.path(section, "upload.R"),
          sprintf(template, headers[[section]]),
          force = force)
    } else {
      safe.cat(file = paste0(section, ".R"),
          sprintf(template, headers[[section]]),
          force = force)
    }
  }

  invisible(getwd())
}
