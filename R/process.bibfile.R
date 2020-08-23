#' @rdname icesTAF-internal
#'
#' @importFrom bibtex read.bib
#'
#' @export

## Process *.bib file

process.bibfile <- function(type, clean = TRUE, quiet = FALSE)
{
  # check type arg
  type <- match.arg(type, c("data", "software"))

  if (clean && type == "data")
  {
    clean.data(quiet = quiet)
  }
  if (clean && type == "software")
  {
    clean.software(quiet = quiet)
    clean.library(quiet = quiet)
  }

  if (!quiet) {
    message("Processing ", paste0(toupper(type), ".bib"))
  }

  entries <- taf.sources(type)
  sapply(entries, process.entry, quiet = quiet)
}
