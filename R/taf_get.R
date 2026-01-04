#' Get a url
#'
#' Get a url, optionally using an ICES authentication token
#'
#' @param url the url to get.
#' @param retry should the get request be retried if first attempt
#'   fails? default TRUE.
#' @param quiet should all messages be suppressed, default FALSE.
#' @param verbose should verbose output form the http request be
#'   returned? default FALSE.
#' @param content should content be returned, or the full http response?
#'   default TRUE, i.e. content is returned by default.
#' @param use_token should an authentication token be sent with the
#'   request? default is the value of the option icesSAG.use_token.
#'
#' @return content or an http response.
#'
#' @seealso
#' \code{\link{taf_api}} builds a SAG web service url.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' taf_get(taf_api("FLStocks"))
#' }
#' @export
#'
#' @importFrom icesConnect ices_get
#' @importFrom httr content
taf_get <- function(url, retry = TRUE, quiet = getOption("icesTAF.messages") %||% FALSE, verbose = FALSE, content = TRUE, use_token = getOption("icesTAF.use_token") %||% FALSE) {
  ices_get(url, retry, quiet, verbose, content, use_token)
}

#' @describeIn taf_get cached version of taf_get
#' @export
taf_get_cached <- taf_get
