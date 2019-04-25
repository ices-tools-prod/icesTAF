#' Convert Spaces
#'
#' Convert spaces in filenames.
#'
#' @param file filename, e.g. \code{"file name.csv"}, \code{"*.csv"}, or
#'        \code{"dir/*"}.
#' @param sep character to use instead of spaces.
#'
#' @return \code{TRUE} for success, \code{FALSE} for failure, invisibly.
#'
#' @seealso
#' \code{\link{file.rename}} is the base function to rename files.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' write(pi, "A B.txt")
#' convert.spaces("A B.txt")
#'
#' ## Many files
#' convert.spaces("bootstrap/initial/data/*")
#' }
#'
#' @export

convert.spaces <- function(file, sep="_")
{
  ## Include both glob matches and filenames without asterisk,
  ## in case some filenames without asterisk are not found
  from <- sort(unique(c(Sys.glob(file), file[!grepl("\\*", file)])))
  from <- grep(" ", from, value=TRUE)

  to <- chartr(" ", sep, from)

  out <- suppressWarnings(mapply(file.rename, from, to))
  if(length(out) == 0)
    out <- NULL

  invisible(out)
}
