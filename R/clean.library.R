## Selectively remove packages from bootstrap/library if not in SOFTWARE.bib

#' @importFrom bibtex read.bib
#' @importFrom remotes parse_repo_spec
#' @importFrom utils packageDescription

clean.library <- function()
{
  lib.entries <- dir("library")

  ## For each package, we select between three cases:
  ## 1 Installed package matches SOFTWARE.bib - do nothing
  ## 2 Installed package is not the version listed in SOFTWARE.bib - remove
  ## 3 Installed package is not listed in SOFTWARE.bib - remove

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
      sha.bib <- "Not listed"
    }

    ## If installed package is either a mismatch or not listed, we remove it
    if(sha.lib != sha.bib)
      unlink(file.path("library", lib), recursive=TRUE)
  }
}
