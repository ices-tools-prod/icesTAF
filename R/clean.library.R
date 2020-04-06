#' Clean TAF Library
#'
#' Selectively remove packages from the local TAF library if not listed in
#' \verb{SOFTWARE.bib}.
#'
#' @param folder location of local TAF library.
#' @param quiet whether to suppress messages about removed packages.
#' @param force whether to remove the local TAF library, regardless of how it
#'        compares to SOFTWARE.bib entries.
#'
#' @note
#' For each package, the cleaning procedure selects between three cases:
#' \enumerate{
#' \item Installed package matches \verb{SOFTWARE.bib} - do nothing.
#' \item Installed package is not the version listed in \verb{SOFTWARE.bib} -
#'       remove.
#' \item Installed package is not listed in \verb{SOFTWARE.bib} - remove.
#' }
#'
#' The \code{taf.bootstrap} procedure cleans the TAF library, without requiring
#' the user to run \code{clean.library}. The main reason for a TAF user to run
#' \code{clean.library} directly is to experiment with installing and removing
#' different versions of software without modifying the \verb{SOFTWARE.bib}
#' file.
#'
#' The command \code{clean("bootstrap/library")} removes that directory
#' completely.
#'
#' @seealso
#' \code{\link{taf.bootstrap}} calls \code{clean.library} as part of the default
#' bootstrap procedure.
#'
#' \code{\link{taf.install}} installs a package in the local TAF library.
#'
#' \code{\link{clean.software}} cleans the local TAF software folder.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @importFrom bibtex read.bib
#' @importFrom utils packageDescription
#'
#' @export

clean.library <- function(folder="bootstrap/library", quiet=FALSE, force=FALSE)
{
  installed <- dir(folder)

  if(!file.exists(file.path(folder, "../SOFTWARE.bib")) || force)
  {
    unlink(folder, recursive=TRUE)
  }
  else
  {
    bib <- read.bib(file.path(folder, "../SOFTWARE.bib"))

    for(pkg in installed)
    {
      ## Read sha.inst, the SHA for an installed package
      sha.inst <- packageDescription(pkg, lib.loc=folder)$RemoteSha
      ## Read sha.bib, the corresponding SHA from SOFTWARE.bib
      if(pkg %in% names(bib))
      {
        repo <- bib[pkg]$source
        spec <- parse.repo(repo)
        sha.bib <- get.remote.sha(spec$username, spec$repo, spec$ref)
        sha.inst <- substring(sha.inst, 1, nchar(sha.bib))  # same length
      }
      else
      {
        sha.bib <- "Not listed"
      }

      ## If installed package is either a mismatch or not listed, then remove it
      if(sha.inst != sha.bib)
      {
        unlink(file.path(folder, pkg), recursive=TRUE)
        if(!quiet)
          message("  cleaned ", file.path(folder, pkg))
      }
    }
  }

  rmdir(folder)
}
