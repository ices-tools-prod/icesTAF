#' Import a bootstrap data script from ICES datasets repo
#'
#' Download an \file{R} file from the ICES datasets repo to fetch
#' data including adding metadata via roxygen2 fields to the top of the file.
#'
#' @param name the name of the dataset and the file name that will be
#'        created.
#' @param commit should the bootstrap file be added and committed to the
#'        analysis
#'
#' @examples
#' \dontrun{
#'
#' # Create bootstrap folder
#' mkdir(taf.boot.path())
#'
#' # Create bootstrap script, bootstrap/mydata.R
#' add.data.script(name = "vms")
#'
#' # Create metadata, bootstrap/DATA.bib
#' taf.roxygenise(files = "vms.R")
#'
#' # Run bootstrap script, creating bootstrap/data/vms/...
#' taf.bootstrap()
#' }
#'
#' @importFrom TAF taf.boot.path
#'
#' @export


add.data.script <- function(name, commit = FALSE) {
  message(
    "browse TAF dataset scripts at:\n",
    "    https://github.com/ices-taf/datasets"
  )

  script <-
    readLines(
      sprintf("https://raw.githubusercontent.com/ices-taf/datasets/main/%s.R", name)
    )

  cat(
    script,
    sep = "\n",
    file = taf.boot.path(sprintf("%s.R", name))
  )

  if (commit) {
    loadpkg("git2r")
    git2r::add(".", taf.boot.path(sprintf("%s.R", name)))
    git2r::commit(".", sprintf("added TAF dataset %s.R", name))
  }

  message(
    "to add dataset to analysis run:\n\n",
    "# register script in DATA.bib\n",
    "taf.roxygenise()\n",
    "# fetch data\n",
    "taf.bootstrap()\n"
  )
}
