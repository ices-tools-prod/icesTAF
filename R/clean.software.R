#' Clean TAF Software
#'
#' Selectively remove software from the local TAF software folder if not listed
#' in \verb{SOFTWARE.bib}.
#'
#' @param folder location of local TAF software folder.
#' @param quiet whether to suppress messages about removed software.
#' @param force whether to remove the local TAF software folder, regardless of
#'        how it compares to SOFTWARE.bib entries.
#'
#' @note
#' For each file (and subdirectory) in the software folder, the cleaning
#' procedure selects between three cases:
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
#' \code{\link{taf.bootstrap}} calls \code{clean.software} as part of the
#' default bootstrap procedure.
#'
#' \code{\link{download.github}} downloads a GitHub repository.
#'
#' \code{\link{clean.library}} cleans the local TAF library.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @importFrom bibtex read.bib
#'
#' @export

clean.software <- function(folder="bootstrap/software", quiet=FALSE,
                           force=FALSE)
{
  software.files <- dir(folder, full.names=TRUE)

  if(!file.exists(file.path(folder, "../SOFTWARE.bib")) || force)
  {
    unlink(folder, recursive=TRUE)
  }
  else
  {
    bib <- read.bib(file.path(folder, "../SOFTWARE.bib"))

    for(file in software.files)
    {
      ## Read sha.file, the SHA for a software file
      pkg <- sub(".*/(.*)_.*", "\\1", file)         # path/pkg_sha.tar.gz -> pkg
      sha.file <- sub(".*_(.*?)\\..*", "\\1", file) # path/pkg_sha.tar.gz -> sha
      ## Read sha.bib, the corresponding SHA from SOFTWARE.bib
      if(pkg %in% names(bib))
      {
        repo <- bib[pkg]$source
        spec <- parse.repo(repo)
        sha.bib <- get.remote.sha(spec$username, spec$repo, spec$ref)
      }
      else
      {
        sha.bib <- "Not listed"
      }

      ## If software file is either a mismatch or not listed, then remove it
      if(sha.file != sha.bib)
      {
        unlink(file, recursive=TRUE, force=TRUE)
        if(!quiet)
          message("  cleaned ", file)
      }
    }
  }

  rmdir(folder)
}
