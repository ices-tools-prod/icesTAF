#' Read an Artifact File
#'
#' Read and validate an artifact file.
#'
#' @param file the name of the artifacts file to read
#' @param check logical, should the artifact be checked for validity?
#'
#' @importFrom jsonlite read_json
#'
#' @export
read.artifacts <- function(file = "ARTIFACTS.json", check = TRUE) {
  out <- read_json(file)

  lapply(out, function(x) {
    do.call(
      artifact,
      c(
        path = x$file,
        type = x$type,
        x$metadata,
        check = check
      )
    )
  })
}