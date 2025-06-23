#' Get a List of TAF Artifacts
#'
#' Get a list of TAF artifacts and thier metadata, i.e., all the FLStocks,
#' SAG upload files, RCEF files, and other files uploaded to TAF.
#'
#' @param year the assessment year, e.g. 2015, default all years.
#' @param stock a stock name, e.g. lin.27.5a, default all stocks.
#' @param ... arguments passed to \code{\link{taf_get}}.
#'
#' @return A data frame.
#'
#' @seealso
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @author Colin Millar.
#'
#' @examples
#' \dontrun{
#' artifacts <- get.artifacts(2023)
#' nshad_artifacts <- get.artifacts(stock = "had.27.46a20")
#' }
#' @export

get.artifacts <- function(year = NULL, stock = NULL, ...) {
  artifacts <- taf_get(taf_api("Artifacts", year = year, stock = stock), use_token = TRUE)

  out <-
    unclass(
      by(
        artifacts,
        artifacts$type,
        function(x) {
          metadata <- t(sapply(x[["metadata"]], function(x) x$name))
          metadata <- type.convert(as.data.frame(metadata), as.is = TRUE)
          names(metadata) <- x[["metadata"]][[1]]$codeType

          #data.frame(id = x$id, type = x$type, fileName = x$fileName)
          cbind(x[c("id", "type")], metadata, x["fileName"])
        }
      )
    )

  out_names <- names(out)
  attributes(out) <- NULL
  names(out) <- out_names

  out
}
