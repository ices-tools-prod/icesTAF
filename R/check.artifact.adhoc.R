check.artifact.adhoc <- function(file) {
  if (!file.exists(file)) {
    warning("File does not exist: ", file, call. = FALSE)
    return(FALSE)
  }

  TRUE
}
