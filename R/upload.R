#' Upload File to TAF Database
#'
#' Upload a file containing raw data to the TAF database.
#'
#' @param analysis name of TAF analysis, e.g. \code{2015_rjm-347d}.
#' @param file filename, e.g. \code{surveys_all.csv}.
#'
#' @note
#' The file will be stored in the TAF database and made available in the
#' \file{raw} directory on the file server, e.g.
#' \url{http://taf.ices.local/taf/fs/2015_rjm-347d/raw/catch.csv}.
#'
#' The term \emph{raw data} refers to the initial data step to be archived.
#' These archived data files are the basis of all subsequent analysis, and
#' guarantee that the TAF analysis can be rerun later and will reproduce the
#' original results, even if data values in the underlying databases (outside of
#' TAF) may have changed after the original analysis was submitted.
#'
#' One objective of TAF is to document the data preparation. Therefore, the raw
#' data files should represent the original data before the main preprocessing
#' and data aggregation takes place. For example, the raw data could be the
#' result of an SQL database query, selecting one species of interest and all
#' relevant data columns for the analysis.
#'
#' @seealso
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' upload("2015_rjm-347d", "surveys_all.csv")
#' }
#'
#' @importFrom httr POST upload_file
#'
#' @export

upload <- function(analysis, file)
{
  file <- upload_file(file)
  url <- sprintf("http://taf.ices.local/taf/fs/%s/raw/%s",
                 analysis, basename(file$path))
  POST(url, body=file)
}
