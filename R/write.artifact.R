#' Write an Artifact File
#'
#' Validate and write an artifact file.
#'
#' @param ... a list of artifact objects made using \code{artifact}.
#' @param append logical, should the new artifacts be appended to the
#'               existing file?
#' @param check logical, should the artifact be checked for validity?
#'
#' @importFrom jsonlite write_json
#' @importFrom jsonlite read_json
#' @export
write.artifacts <- function(..., append = TRUE, check = TRUE) {
  artifacts <- list(...)

  # remove duplicates
  hashes <- sapply(artifacts, "[[", "hash")
  artifacts <- artifacts[!duplicated(hashes)]

  # only add new artifacts to file
  if (file.exists("ARTIFACTS.json") && append) {

    existing_artifacts <- read.artifacts("ARTIFACTS.json")
    existing_hashes <- sapply(existing_artifacts, "[[", "hash")
    existing_artifacts <- existing_artifacts[!duplicated(existing_hashes)]

    artifacts <-
      c(
        existing_artifacts,
        artifacts[!sapply(artifacts, "[[", "hash") %in% existing_hashes]
      )
  } else {
    unlink("ARTIFACTS.json")
  }

  # check artifacts
  if (check) {
    lapply(artifacts, check.artifact)
  }

  write_json(artifacts, path = "ARTIFACTS.json", pretty = TRUE, auto_unbox = TRUE)
}
