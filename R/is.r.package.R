#' Is R Package
#'
#' Check if \file{.tar.gz} file is an R package.
#'
#' @param targz a filename ending with \verb{tar.gz}.
#' @param spec an optional list generated with \code{parse.repo}.
#' @param warn whether to warn if the file contents look like an R package
#'        nested inside a repository.
#' @param quiet whether to suppress messages.
#'
#' @return Logical indicating whether \code{targz} is an R package.
#'
#' @importFrom utils untar
#'
#' @export

is.r.package <- function(targz, spec=NULL, warn=TRUE, quiet=FALSE)
{
  contents <- untar(targz, list=TRUE)
  if("DESCRIPTION" %in% sub(".*?/", "", contents))  # DESCRIPTION in top dir
  {
    ans <- TRUE
  }
  else if("DESCRIPTION" %in% basename(contents))  # DESCRIPTION in subdir
  {
    subdir <- basename(dirname(contents[basename(contents) == "DESCRIPTION"]))
    suggestion <- if(is.null(spec)) NULL
                  else paste0("- did you mean\n  source = {", spec$username,
                              "/", spec$repo, "/", subdir, "@", spec$ref, "}")
    if(warn)
      warning("looks like an R package inside a repository", suggestion)
    ans <- FALSE
  }
  else # no DESCRIPTION file found
  {
    if(!quiet)
      message("  not an R package")
    ans <- FALSE
  }
  ans
}
