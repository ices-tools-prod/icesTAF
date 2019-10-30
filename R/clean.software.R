#' Clean TAF Software
#'
#' Selectively remove software from the local TAF software folder if not listed
#' in \verb{SOFTWARE.bib}.
#'
#' @param folder location of local TAF software folder.
#' @param quiet whether to suppress messages about removed software.
#'
#' @note
#' For each file in the software folder, the cleaning procedure selects between
#' three cases:
#' \enumerate{
#' \item File and version matches \verb{SOFTWARE.bib} - do nothing.
#' \item Filename does not contain the version listed in \verb{SOFTWARE.bib} -
#'       remove.
#' \item File is not listed in \verb{SOFTWARE.bib} - remove.
#' }
#'
#' The \code{taf.bootstrap} procedure cleans the TAF software folder, without
#' requiring the user to run \code{clean.software}. The main reason for a TAF
#' user to run \code{clean.software} directly is to experiment with installing
#' and removing different versions of software without modifying the
#' \verb{SOFTWARE.bib} file.
#'
#' The command \code{clean("bootstrap/software")} removes that directory
#' completely.
#'
#' @seealso
#' \code{\link{taf.bootstrap}} calls \code{clean.software} as a part of the
#' default bootstrap procedure.
#'
#' \code{\link{clean.library}} cleans the local TAF library.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @importFrom bibtex read.bib
#' @importFrom remotes parse_repo_spec
#'
#' @export

clean.software <- function(folder="bootstrap/software", quiet=FALSE)
{
  software.files <- dir(folder, full.names=TRUE)

  for(file in software.files)
  {
    ## Read sha.file, the SHA for a software file
    pkg <- sub(".*/(.*)_.*", "\\1", file)          # path/pkg_sha.tar.gz -> pkg
    sha.file <- sub(".*_(.*?)\\..*", "\\1", file)  # path/pkg_sha.tar.gz -> sha
    ## Read sha.bib, the corresponding SHA from SOFTWARE.bib
    bib <- read.bib(file.path(folder, "../SOFTWARE.bib"))
    if(pkg %in% names(bib))
    {
      repo <- bib[pkg]$source
      spec <- parse_repo_spec(repo)
      sha.bib <- get_remote_sha(spec$username, spec$repo, spec$ref)
      sha.bib <- substring(sha.bib, 1, 7)
    }
    else
    {
      sha.bib <- "Not listed"
    }

    ## If software file is either a mismatch or not listed, then remove it
    if(sha.file != sha.bib)
    {
      unlink(file.path(folder, pkg), recursive=TRUE)
      if(!quiet)
        message("  cleaned ", file.path(folder, pkg))
    }
  }

  rmdir(folder)
}
