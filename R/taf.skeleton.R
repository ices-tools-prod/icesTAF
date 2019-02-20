#' TAF Skeleton
#'
#' Create initial directories and R scripts for a new TAF analysis.
#'
#' @param name main directory name for the analysis.
#' @param path path to create the analysis directory in.
#' @param force whether to overwrite existing scripts.
#'
#' @details
#' Use \code{name = "."} to create initial directories and scripts inside the
#' current working directory.
#'
#' @return Full path to analysis directory.
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
  safe.cat <- function(..., file, force) {
    if (!file.exists(file) || force) {
      cat(..., file = file)
    }
  }

  # create analysis directory
  mkdir(file.path(path, name))
  owd <- setwd(file.path(path, name))
  on.exit(setwd(owd))

  # create initial directories
  mkdir("bootstrap/initial/data")

  # define headers
  template <- paste0("## %s\n\n## Before:\n## After:\n\n",
                     "library(icesTAF)\n\nmkdir(\"%s\")\n\n")
  headers <- list(
    data = "Preprocess data, write TAF data tables",
    model = "Run analysis, write model results",
    output = "Extract results of interest, write TAF output tables",
    report = "Prepare plots/tables for report")

  # create TAF scripts
  for (section in names(headers)) {
    safe.cat(sprintf(template, headers[[section]], section),
             file = paste0(section, ".R"),
             force = force)
  }

  invisible(getwd())
}
