check.artifact.FLStock <- function(file) {
  if (tools::file_ext(file) != "rds") {
    warning("File must be an RDS file with extension '.rds': ", file, call. = FALSE)
    return(FALSE)
  }

  if (!requireNamespace("FLCore", quietly = TRUE)) {
    warning("FLCore not available... skipping check", call. = FALSE)
  } else {
    stk <- readRDS(file)

    if (!inherits(stk, "FLStock")) {
      warning("Object is not an FLStock: ", file, call. = FALSE)
      return(FALSE)
    }

    # check if object is valid
    validity <- validObject(ple4)

    # run type specific checks
    tests <- FLCore::verify(stk)

    if (any(!tests$valid)) {
      return(tests[!tests$valid, ])
    }
  }

  invisible(TRUE)
}
