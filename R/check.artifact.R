
#' @importFrom icesVocab getCodeList getCodeTypeList
#' @importFrom utils capture.output type.convert
check.artifact <- function(artifact, check.metadata = TRUE, quiet = FALSE) {
  fail <- FALSE

  # check metadata
  if (check.metadata) {
    # use icesVocab to check metadata (possible port to icesVocab)
    vocabCodeTypes <- getCodeTypeList()

    codeTypes <- names(artifact$metadata)
    invalidCodeTypes <- codeTypes[!codeTypes %in% vocabCodeTypes$Key]
    for (invalidCodeType in invalidCodeTypes) {

      warning("Invalid metadata code type: ", invalidCodeType, "\n", call. = FALSE)
      ids <- grep(invalidCodeType, vocabCodeTypes$Key)
      suggestions <-
        do.call(
          rbind,
          lapply(ids, function(id) {
            data.frame(
              codeType = vocabCodeTypes$Key[id],
              url = paste0("https://vocab.ices.dk/?codetypeguid=", vocabCodeTypes$GUID[id])
            )
          })
        )

      if (!is.null(suggestions)) {
        warning(
          "perhaps you meant: \n",
          paste(capture.output(suggestions), collapse = "\n"), "\n",
          call. = FALSE
        )
      }
    }

    if(length(invalidCodeTypes) > 0) {
      fail <- TRUE
    }

    validCodeTypes <- codeTypes[codeTypes %in% vocabCodeTypes$Key]

    invalidCodes <-
      do.call(
        rbind,
        lapply(validCodeTypes, function(key) {
          vocabCodes <- getCodeList(key)
          if (!artifact$metadata[[key]] %in% vocabCodes$Key) {
            data.frame(
              code = key,
              value = artifact$metadata[[key]],
              url =
                paste0(
                  "https://vocab.ices.dk/?codetypeguid=",
                  vocabCodeTypes$GUID[vocabCodeTypes$Key == key])
            )
          } else {
            NULL
          }
        })
      )

    if (!is.null(invalidCodes)) {
      warning(
        "Invalid metadata codes: \n",
        paste(capture.output(invalidCodes), collapse = "\n"), "\n",
        call. = FALSE
      )
      fail <- TRUE
    }
  }

  # run type specific checks
  if (!file.exists(artifact$file)) {
    warning("File does not exist: ", artifact$file, "\n")
    fail <- TRUE
    typeok <- FALSE
  } else {
    check.func <- get(paste0("check.artifact.", artifact$type), envir = parent.frame())

    typeok <- check.func(artifact$file)

    if (!identical(typeok, TRUE)) {
      warning(
        "Artifact type (", artifact$type, ") checks failed: \n",
        paste(capture.output(typeok), collapse = "\n"), "\n",
        call. = FALSE
      )
    }
  }

  if (identical(typeok, TRUE)) {
    if (!fail) {
      if (!quiet) msg("Artifact check passed")
      TRUE
    } else {
      FALSE
    }
  } else {
    invisible(typeok)
  }
}
