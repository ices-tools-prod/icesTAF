#' @rdname icesTAF-internal
#'
#' @importFrom bibtex read.bib
#'
#' @export

## Process *.bib file

process.bibfile <- function(bibfile, clean=TRUE, quiet=FALSE)
{
  if (!quiet) {
    message("Processing ", bibfile)
  }

  if (bibfile == "DATA.bib") {
    type <- "data"
  } else if (bibfile == "SOFTWARE.bib") {
    type <- "software"
  } else {
    stop("bibfile must be 'DATA.bib' or 'SOFTWARE.bib'")
  }

  if (clean && type=="data")
  {
    clean.data("data", quiet=quiet)
  }
  if (clean && type=="software")
  {
    clean.software("software", quiet=quiet)
    clean.library("library", quiet=quiet)
  }

  entries <- if (file.exists(bibfile)) read.bib(bibfile) else list()
  dups <- anyDuplicated(names(entries))
  if (dups) {
    stop("Duplicated key: '", names(entries)[dups], "'")
  }

  for(bib in entries)
  {
    process.entry(bib, dir, quiet)
  }
}
