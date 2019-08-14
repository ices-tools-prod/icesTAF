#' Source Directory
#'
#' Read all \code{*.R} files from a directory containing R functions.
#'
#' @param dir a directory containing R source files.
#' @param pattern passed to \code{\link{dir}} when selecting files.
#' @param all.files passed to \code{dir} when selecting files.
#' @param recursive passed to \code{dir} when selecting files.
#' @param quiet whether to suppress messages.
#' @param \dots passed to \code{source} when sourcing files.
#'
#' @details
#' The \code{dir} argument can also be a vector of filenames, instead of a
#' directory  name. This can be useful to specify certain files while avoiding
#' others.
#'
#' @return Names of sourced files.
#'
#' @note
#' This function is convenient in TAF analyses when many R utility functions are
#' stored in a directory, see example below.
#'
#' @seealso
#' \code{\link{source}} is the base function to read R code from a file.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' sourceDir("bootstrap/software/utilities")
#' }
#'
#' @export

sourceDir <- function(dir, pattern="\\.[r|R]$", all.files=FALSE,
                      recursive=FALSE, quiet=TRUE, ...)
{
  files <- if(!dir.exists(dir[1])) dir
           else dir(dir, full.names=TRUE, pattern=pattern,
                    all.files=all.files, recursive=recursive)

  sapply(files, function(f)
  {
    if(!quiet)
      cat("  ", f, "\n", sep="")
    source(f, ...)
  })

  invisible(files)
}
