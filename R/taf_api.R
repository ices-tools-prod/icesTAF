#' Build a SAG web service url
#'
#' utility to build a url with optional query arguments
#'
#' @param service the name of the service
#' @param ... name arguments will be added as queries
#'
#' @return a complete url as a character string
#'
#' @examples
#'
#' taf_api("hi", bye = 21)
#' taf_api("FLStocks")
#'
#' @export
#' @importFrom httr parse_url build_url
taf_api <- function(service, ...) {
  url <- paste0(api_url(), "/", service)
  url <- parse_url(url)
  url$query <- list(...)
  url <- build_url(url)

  url
}

api_url <- function() {
  "https://taf.ices.dk/api"
}
