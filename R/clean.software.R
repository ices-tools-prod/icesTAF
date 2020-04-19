#' Clean TAF Software
#'
#' Selectively remove software from the local TAF software folder if not listed
#' in \verb{SOFTWARE.bib}.
#'
#' @param folder location of local TAF software folder.
#' @param quiet whether to suppress messages about removed software.
#' @param force whether to remove the local TAF software folder, regardless of
#'        how it compares to \verb{SOFTWARE.bib} entries.
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
#' @seealso
#' \code{\link{taf.bootstrap}} calls \code{clean.software} as part of the
#' default bootstrap procedure.
#'
#' \code{\link{download.github}} downloads a GitHub repository.
#'
#' \code{\link{clean.library}} cleans the local TAF library.
#'
#' \code{\link{clean.data}} cleans the \verb{bootstrap/data} folder.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' clean.software()
#' }
#'
#' @importFrom bibtex read.bib
#'
#' @export

clean.software <- function(folder="bootstrap/software", quiet=FALSE,
                           force=FALSE)
{
  if(!file.exists(file.path(folder, "../SOFTWARE.bib")) || force)
  {
    unlink(folder, recursive=TRUE)
  }
  else
  {
    bib <- read.bib(file.path(folder, "../SOFTWARE.bib"))
    for(file in dir(folder, full.names=TRUE))
    {
      ## Check if filename looks like GitHub software, e.g. model_13579bd.tar.gz
      if(grepl("_[a-f0-9]{7}\\.tar\\.gz", substring(file, nchar(file)-14)))
      {
        ## Read sha.file, the SHA for a software file
        pkg <- sub(".*/(.*)_.*", "\\1", file)         # bs/pkg_sha.tar.gz -> pkg
        sha.file <- sub(".*_(.*?)\\..*", "\\1", file) # bs/pkg_sha.tar.gz -> sha
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
        delete <- sha.file != sha.bib
      }
      else  # filename is either a folder or plain file, e.g. model or model.exe
      {
        delete <- !(basename(file) %in% names(bib))
      }
      if(delete)
      {
        unlink(file, recursive=TRUE, force=TRUE)
        if(!quiet)
          message("  cleaned ", file)
      }
    }
  }
  rmdir(folder)
}
