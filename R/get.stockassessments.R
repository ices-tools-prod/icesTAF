#' @export
get.stockassessments <- function() {
  url <- "https://taf.ices.dk/repomanager/api/assessments"

  res <- httr::GET(url)

  out <- httr::content(res, simplifyVector = TRUE)

  out
}
