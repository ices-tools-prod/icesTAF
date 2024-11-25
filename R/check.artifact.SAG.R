#' @importFrom icesSAG readSAGxml
#' @importFrom icesDatsu getDataFieldsDescription
#' @importFrom icesVocab getCodeList
check.artifact.SAG <- function(file) {
  if (tools::file_ext(file) != "xml") {
    warning("File must be an XML file with extension '.xml': ", file, call. = FALSE)
    return(FALSE)
  }

  sagxml <- readSAGxml(file)
  info <- sagxml$info[!sapply(sagxml$info, is.na)]

  feilds <- getDataFieldsDescription(126, "AA")
  vocabs <- feilds[!is.na(feilds$codeGroup), ]
  vocabList <- sapply(unique(vocabs$codeGroup), function(x) getCodeList(x)$Key)

  # hack to check info part
  metadata <- info[intersect(names(info), vocabs$fieldcode)]
  names(metadata) <- vocabs$codeGroup[match(names(metadata), vocabs$fieldcode)]
  hack <-
    do.call(
      artifact,
      c(
        path = file,
        type = "adhoc",
        metadata,
        check = FALSE
      )
    )
  ok <- check.artifact(hack, quiet = TRUE)

  # check xml file using datsu....
  msg("Still to code DATSU checks for SAG artifacts")

  if (!ok) {
    "SAG info part failed"
  } else {
    TRUE
  }
}
