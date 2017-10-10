#' Create a Skeleton for a New TAF Analysis
#'
#' \code{taf.skeleton()} is motivated by \code{package.skeleton}. It automates
#' some of the setup for a new TAF analysis. It creates directories, saves functions,
#' data, and R code files to appropriate places, and creates a ‘Read-and-delete-me’
#' file describing further steps to create a functioning TAF analysis.
#'
#'
#' @param name character string: the name and directory name for your analysis,
#'             if NULL then it effectively assumes the parent directory name as the
#'             analysis name.
#' @param path path to put the analysis directory in.
#' @param force	If FALSE will not overwrite an existing directory.
#'
#' @export

taf.skeleton <- function (name = "aTAFanalysis", path = ".",
                          force = FALSE)
{
  owd <- setwd(path)
  on.exit(setwd(owd))
  # create analysis directory
  if (!is.null(name)) {
    mkdir(name)
    setwd(name)
  }

  # create directory structure
  mkdir("_raw")
  mkdir("_config")

  # add in basic R files with header info
  header_template <- "## %s\n\n## Before:\n## After:"
  headers <- list(`_raw` = "Upload raw data to TAF database",
                  data = "Preprocess data, write TAF data tables",
                  input = "Convert data to model format, write model input files",
                  model = "Run analysis, write model results",
                  output = "Extract model results of interest, write TAF output tables",
                  report = "Plot data and results")

  safe.cat <- function(..., file, force, sep = " ", fill = FALSE, labels = NULL, append = FALSE) {
    if (file.exists(file) && force) {
      unlink(file)
    }
    cat(..., file = file, sep = sep, fill = fill, labels = labels, append = append)
  }

  for (section in names(headers)) {
    if (section == "_raw") {
      safe.cat(file = file.path(section, "upload.R"),
          sprintf(header_template, headers[[section]]),
          force = force)
    } else {
      safe.cat(file = paste0(section, ".R"),
          sprintf(header_template, headers[[section]]),
          force = force)
    }
  }

  # check names of list entries:
  #   - should be _raw, _config, scripts?

  # return directory created analysis
  return(path.expand(path))
}

