## Selectively remove packages from bootstrap/library if not in SOFTWARE.bib

#' @importFrom bibtex read.bib
#' @importFrom remotes parse_repo_spec
#' @importFrom utils packageDescription

clean.library <- function()
{
  lib.entries <- dir("library")

  for(lib in lib.entries)
  {
    ## Read sha.lib, the SHA for an installed package
    sha.lib <- packageDescription(lib, lib.loc="library")$RemoteSha
    ## Read sha.bib, the corresponding SHA from SOFTWARE.bib
    bib <- read.bib("SOFTWARE.bib")
    if(lib %in% names(bib))
    {
      repo <- bib[lib]$source
      spec <- parse_repo_spec(repo)
      sha.bib <- get_remote_sha(spec$username, spec$repo, spec$ref)
      sha.bib <- substring(sha.bib, 1, 7)
    }
    else
    {
      sha.bib <- "Not listed in SOFTWARE.bib"
    }

    ## If installed package is either old or not requested, we remove it
    if(sha.lib != sha.bib)
      unlink(file.path("library", lib), recursive=TRUE)
  }
}
