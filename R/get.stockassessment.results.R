#' @export
get.stockassessment.results <- function(tag, type = "harvest", asFLQuant = FALSE) {
  type <- match.arg(type, "harvest")

  url <-
    file.path(
      "https://taf.ices.dk/repomanager/api/assessments",
      URLencode(tag, reserved = TRUE), type
    )

  if (asFLQuant) {
    url <- paste0(url, "?asFLQuant=true")
  }

  res <- httr::GET(url)

  if (asFLQuant) {
    out <- httr::content(res, as = "text", encoding = "UTF-8")
    # try and load FLCore
    tryCatch(getNamespace("FLCore"), error = function(e) {
      stop(
        "Required package FLCore not found. Please run: install.packages('FLCore', repos='http://flr-project.org/R')",
        call. = FALSE
      )
    })

    eval(parse(text = out))
  }
  else {
    out <- httr::content(res, simplifyVector = TRUE)
    long2taf(out[c("year", "age", "value")])
  }
}
