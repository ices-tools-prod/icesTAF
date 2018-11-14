#' TAF Citations
#'
#' Generate BibTeX references, based on data citations file and TAF repository
#' metadata.
#'
#' @param file data citations file.
#'
#' @return
#' Data frame containing data filenames and description.
#'
#' @export

taf.citations <- function(file)
{
  x <- trimws(readLines(file))
  x <- x[x != ""]
  x <- sub("^[ \t]*#*[ \t]*", "", x)
  out <- matrix(x, ncol=2, byrow=TRUE,
                dimnames=list(NULL,c("File","Description")))
  as.data.frame(out)
}
