#' Upload File to TAF Database
#'
#' Upload a file to the TAF database, either \emph{raw} data or a \emph{model}
#' executable.
#'
#' @param analysis name of TAF analysis.
#' @param type file type, either \code{"raw"} or \code{"model"}.
#' @param file filename.
#'
#' @section Raw data:
#' Raw data refers to the initial data step to be archived. These files are the
#' basis of all subsequent analysis, and guarantee that the TAF analysis can be
#' rerun later and will reproduce the original results, even if data in the
#' underlying databases (outside of TAF) may have changed after the original
#' analysis was submitted.
#'
#' One objective of TAF is to document the data preparation. Therefore, the raw
#' data files should represent the original data before the main preprocessing
#' and data aggregation takes place. For example, the raw data could be the
#' result of an SQL database query, selecting one species of interest and all
#' relevant data columns for the analysis.

#' @section Model executables:
#' When using a model that is not in the ICES Toolbox of stock assessment
#' models, the model executables are uploaded to the TAF database before the
#' model is run.
#'
#' To make the analysis reproducible across platforms, two executables should be
#' uploaded, one for Linux and one for Windows. The source code is not uploaded
#' in the same way, but is version-controlled with the rest of the TAF analysis.
#'
#' @seealso
#' \code{\link{download}} downloads a file in binary mode.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' upload("2015_rjm-347d", "raw", "surveys_all.csv")
#' }
#'
#' @importFrom httr POST upload_file
#'
#' @export

upload <- function(analysis, type, file)
{
  type <- match.arg(type, c("raw", "model"))
  file <- upload_file(file)
  url <- sprintf("http://taf.ices.local/taf/fs/%s/%s/%s",
                 analysis, type, basename(file$path))
  POST(url, body=file)
}
