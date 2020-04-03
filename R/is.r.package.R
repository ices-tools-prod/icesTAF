#' Is R Package
#'
#' Check if \file{.tar.gz} file is an R package.
#'
#' @param targz a filename ending with \verb{tar.gz}.
#' @param spec an optional list generated with \code{parse.repo}.
#' @param warn whether to warn if the file contents look like an R package
#'        nested inside a repository.
#'
#' @details
#' The only purpose of passing \code{spec} is to get a more helpful warning
#' message if the file contents look like an R package nested inside a
#' repository.
#'
#' @return Logical indicating whether \code{targz} is an R package.
#'
#' @importFrom utils untar
#'
#' @examples
#' \dontrun{
#' is.r.package("bootstrap/software/SAM.tar.gz")
#' is.r.package("bootstrap/software/stockassessment.tar.gz")
#' }
#'
#' @export

is.r.package <- function(targz, spec=NULL, warn=TRUE)
{
  contents <- untar(targz, list=TRUE)
  if("DESCRIPTION" %in% sub(".*?/", "", contents))  # DESCRIPTION in top dir
  {
    ans <- TRUE
  }
  else if("DESCRIPTION" %in% basename(contents))  # DESCRIPTION in subdir
  {
    if(warn)
    {
      subdir <- basename(dirname(contents[basename(contents) == "DESCRIPTION"]))
      suggestion <- if(is.null(spec)) NULL
                    else paste0(" - did you mean\n  source = {", spec$username,
                                "/", spec$repo, "/", subdir, "@", spec$ref, "}")
      warning(subdir, " looks like an R package inside a repository",
              suggestion)
    }
    ans <- FALSE
  }
  else # no DESCRIPTION file found
  {
    ans <- FALSE
  }
  ans
}
