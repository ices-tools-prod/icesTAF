#' Make an Artifact File Entry
#'
#' Form and valid artifact as an export from a TAF repository.
#'
#' @param path The relative path to a file to be added, e.g. "data/indices.csv".
#' @param type the type of output, e.g. FLStock, SAG_upload
#' @param ... a list of metadata to be attributed to the entry.
#' @param check logical, should the artifact be checked for validity?
#' @param quiet logical, should the function be quiet?
#'
#' @importFrom jsonlite unbox
#' @importFrom rlang hash
#' @export
artifact <- function(
    path,
    type = c("adhoc", "FLStock", "SAG", "ASD", "RDBES_national", "RDBES_total"),
    ..., check = TRUE, quiet = FALSE) {
  dots <- list(...)

  type <- match.arg(type)

  if (type == "SAG" && requireNamespace("icesSAG", quietly = TRUE)) {
    if (length(dots) > 0) {
      msg("SAG types do not require metadata")
    }
    try({
      sag <- icesSAG::readSAGxml(path)
      dots <-
        list(
          Year = sag$info$AssessmentYear,
          ICES_StockCode = sag$info$StockCode,
          AssessmentPurpose = sag$info$Purpose
        )
    })
  }

  out <- list(
    file = unbox(path), type = unbox(type),
    metadata = lapply(dots, function(x) unbox(type.convert(x, as.is = TRUE)))
  )
  out$hash <- unbox(hash(out))

  class(out) <- c("list", "taf.artifact")

  if (check) {
    ok <- check.artifact(out, quiet = quiet)
    # stop if check fails?
    if (!identical(ok, TRUE)) stop("Failed to create artifact")
  }

  out
}

#' @export
print.taf.artifact <- function(x, ...) {
  cat("TAF artifact:\n")
  cat("  File: ", x$file, "\n")
  cat("  Type: ", x$type, "\n")
  cat("  Metadata: \n")
  for (i in seq_along(names(x$metadata))) {
    cat("\t", names(x$metadata)[i], x$metadata[[i]], "\n")
  }

  invisible(x)
}
