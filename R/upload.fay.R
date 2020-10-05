#' Upload Fishing Mortality at Age
#'
#' Upload fishing mortality or harvest rate to the ICES TAF results
#' database
#'
#' @param data a dataframe with columns for year followed by columns
#'             for each age, named as the age.
#' @param info a named list corresponding to the required
#'                        information to upload a stock assessment.
#' @param quiet should messages and verbose output be shown.
#' @param only.check logical, if TRUE, the data will be checked and
#'                   no upload will be attempted.
#'
#' @details
#' Upload a table of F at age to the ICES TAF results database.
#' The \code{data} and \code{assessment_info} will be checked against
#' a schema, and any errors reported back to the user as attributes to
#' the FALSE return value.
#'
#' @return TRUE if successfull, FALSE otherwise
#'
#' @note
#' The \code{data} argument expects a data.frame with the first
#' column named "year" as described in the help for
#' \code{\link{xtab2taf}}.
#'
#' @seealso
#' The \code{\link{xtab2taf}} function is to create a data.frame
#'
#' \code{\link{taf.png}} opens a PNG graphics device.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' info <-
#'  list(
#'    valueType = "harvest",
#'    stockCode = "cod.27.47d20"
#'  )
#' upload.fay(catage.taf, info, only.check = TRUE)
#'
#' @export

#' @importFrom jsonlite toJSON
#' @importFrom jsonvalidate json_validate
#' @importFrom httr POST content_type_json verbose
upload.fay <- function(data, info, quiet = TRUE,
                      only.check = FALSE, ...) {

  # fillin missing info
  if (is.null(info$activeYear)) {
    info$activeYear <- as.integer(format(Sys.Date(), "%Y"))
  }
  info$repoTag <- glue("{info$activeYear}_{info$stockCode}_assessment@v0.1")
  if (is.null(info$unit)) {
    # default unit is F
    info$unit <- "F"
  }

  assessment_values <-
    c(
      info,
      list(
        # convert data to long
        values = taf2long(data, names = c("year", "age", "value"))
      )
    )

  if (!quiet) msg("validating upload object")
  json <- toJSON(assessment_values, auto_unbox = TRUE)

  # stop if invalid
  schema <- system.file("schemas/assessment.schema-0.1.json", package = "icesTAF")
  ok <- json_validate(json, schema, verbose = TRUE)
  if (!ok || only.check) {
    return(ok)
  }

  url <- "https://taf.ices.dk/repomanager/api/assessments"

  if (quiet) {
    ret <- POST(url, body = json, content_type_json())
  } else {
    msg("Attempting POST")
    ret <- POST(url, body = json, content_type_json(), verbose())
  }

  if (!quiet) msg(http_condition(status_code(ret), "message")$message)

  # check return value from POST
  ret
}
