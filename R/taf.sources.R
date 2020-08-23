#' Extract sources from TAF *.bib file
#'
#' Extract a list of sources from a TAF *.bib file (i.e. DATA.bib or
#' SOFTWARE.bib). This allows the user to print the lisst of sources
#' but also to process them individualy, giving more flexibiulity when
#' developing larger projects.
#'
#' @param type one of "data", "software" or "both"
#'
#' @seealso
#' \link{process.entry} to process one of the entries returned by
#' `taf.sources`.
#'
#' @export

taf.sources <- function(type) {
  # check type arg
  type = match.arg(type, c("data", "software", "both"))

  bibfile <- file.path("bootstrap", paste0(toupper(type), ".bib"))
  sources <- bibtex::read.bib(bibfile)

  # check for duplicates
  dups <- anyDuplicated(names(sources))
  if (dups) {
    stop("Duplicated key: '", names(sources)[dups], "'")
  }

  # add type feild (data or software)
  sources <-
    lapply(
      sources,
      function(x) {
        x$type <- type
        x
      }
    )
  names(sources) <- NULL
  do.call("c", sources)
}
