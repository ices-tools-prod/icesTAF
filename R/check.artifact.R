#' Check an Artifact File Entry
#'
#' Validate an artifact as an export from a TAF repository.
#'
#' @param artifact an artifact object made using \code{artifact}.
#' @param check.metadata logical, should the metadata be checked against
#'        the ICES Vocabulary database?
#' @param check.type logical, should type specific artifact checks be run?
#' @param quiet logical, should the function be quiet?
#'
#' @examples
#' \dontrun{
#' sag_file <- system.file("SAG", "sol_27_4.xml", package = "icesTAF")
#' sag <- artifact(sag_file, type = "SAG", check = FALSE)
#' check.artifact(sag)
#' }
#'
#' @importFrom icesVocab getCodeList getCodeTypeList
#' @importFrom utils capture.output type.convert
#' @importFrom TAF msg
#'
#' @export
check.artifact <- function(artifact, check.metadata = TRUE, check.type = TRUE, quiet = FALSE) {
  fail <- FALSE

  return_check <- function() {
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

  # check metadata
  if (check.metadata) {
    # check required fields are present!


    # create records in Datsu for TAF artifacts, and check metadata there :)
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

    if (length(invalidCodeTypes) > 0) {
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
                  vocabCodeTypes$Guid[vocabCodeTypes$Key == key]
                )
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

  # does artifact file exist
  if (!file.exists(artifact$file)) {
    warning("File does not exist: ", artifact$file, "\n")
    fail <- TRUE
    typeok <- FALSE
    return(return_check())
  }

  # run type specific checks
  if (check.type) {
    check.func <- paste0("check.artifact.", artifact$type)
    if (!exists(check.func, mode = "function")) {
      warning("No check function for artifact type: ", artifact$type, "\n")
      fail <- TRUE
      typeok <- FALSE

      return(return_check())
    }

    check.func <- get(paste0("check.artifact.", artifact$type))

    typeok <- check.func(artifact$file)

    if (!identical(typeok, TRUE)) {
      warning(
        "Artifact type (", artifact$type, ") checks failed: \n",
        paste(capture.output(typeok), collapse = "\n"), "\n",
        call. = FALSE
      )
    }
  }

  return_check()
}
