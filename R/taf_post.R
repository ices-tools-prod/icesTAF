#' Post to a url
#'
#' Post to a url using an ICES authentication token
#'
#' @param url the url to get.
#' @param body a list of named arguments to be sent as the body of the
#'   post request.
#' @param verbose should verbose output form the http request be
#'   returned? default FALSE.
#'
#' @return content of the http response.
#'
#' @seealso
#' \code{\link{taf_api}} builds a TAF web service url.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @export
#'
#' @importFrom icesConnect ices_post
taf_post <- function(url, body = list(), verbose = FALSE) {
  out <- ices_post(url, body, retry = TRUE, verbose = verbose, content = TRUE, use_token = TRUE, encode = "json")

  return(out)
}
