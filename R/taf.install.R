#' @importFrom remotes install_github parse_repo_spec

taf.install <- function(repo)
{
  spec <- parse_repo_spec(repo)
  url <- paste0("https://api.github.com/repos/",
                spec$username, "/", spec$repo, "/tarball/", spec$ref)
  targz <- paste0(spec$repo, "_", spec$ref, ".tar.gz")
  if(!file.exists(file.path("software", targz)))
    suppressWarnings(download(url, destfile=file.path("software", targz)))
  mkdir("library")
  ## Need to check manually and force=TRUE, since the install_github()
  ## built-in checks get confused if package is installed in another library
  if(already.in.taf.library(spec))
  {
    pkg <- basename(file.path(spec$repo, spec$subdir))
    message("Skipping install of '", pkg, "'.")
    message("  Version '", spec$ref,
            "' is already in the local TAF library.")
  }
  else
  {
    install_github(repo, lib="library", dependencies=FALSE,
                   upgrade=FALSE, force=TRUE)
  }
}

## Check whether requested package is already installed in the TAF library

#' @importFrom utils installed.packages packageDescription

already.in.taf.library <- function(spec)
{
  pkg <- basename(file.path(spec$repo, spec$subdir))
  sha.bib <- spec$ref
  sha.inst <- if(pkg %in% row.names(installed.packages("library")))
                packageDescription(pkg, "library")$RemoteSha else NULL
  sha.inst <- substring(sha.inst, 1, nchar(sha.bib))
  out <- identical(sha.bib, sha.inst)
  out
}
