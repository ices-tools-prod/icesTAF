#' @importFrom tools file_path_sans_ext
#' @importFrom utils install.packages

taf.install <- function(targz, wd=".")
{
  ## Current working directory is bootstrap
  ## targz has the form software/pkg_sha.tar.gz
  owd <- setwd(wd); on.exit(setwd(owd))
  mkdir("library")

  pkg <- sub(".*/(.*)_.*", "\\1", targz)     # software/pkg_sha.tar.gz -> pkg
  sha <- sub(".*_(.*?)\\..*", "\\1", targz)  # software/pkg_sha.tar.gz -> sha

  if(already.in.taf.library(targz))
  {
    message("Skipping install of '", pkg, "'.")
    message("  Version '", sha, "' is already in the local TAF library.")
  }
  else
  {
    install.packages(targz, lib="library")
    ## Store RemoteSha in DESCRIPTION
    desc <- read.dcf(file.path("library", pkg, "DESCRIPTION"), all=TRUE)
    desc$RemoteSha <- sha
    write.dcf(desc, file.path("library", pkg, "DESCRIPTION"))
    ## Store RemoteSha in package.rds
    meta <- readRDS(file.path("library", pkg, "Meta/package.rds"))
    meta$DESCRIPTION["RemoteSha"] <- sha
    saveRDS(meta, file.path("library", pkg, "Meta/package.rds"))
  }
}

## Check whether requested package is already installed in the TAF library

#' @importFrom utils installed.packages packageDescription

already.in.taf.library <- function(targz)
{
  pkg <- sub(".*/(.*)_.*", "\\1", targz)
  sha.tar <- sub(".*_(.*?)\\..*", "\\1", targz)

  sha.inst <- if(pkg %in% row.names(installed.packages("library")))
                packageDescription(pkg, "library")$RemoteSha else NULL
  sha.inst <- substring(sha.inst, 1, nchar(sha.tar))
  identical(sha.tar, sha.inst)
}

## Get the SHA code of the remote for a given reference

#' @importFrom jsonlite read_json
#' @importFrom utils URLencode download.file

## Internal use examples:
## icesTAF:::get_remote_sha("ices-tools-prod", "icesTAF", "master")
## icesTAF:::get_remote_sha("ices-tools-prod", "icesTAF", "3.1-1")
## icesTAF:::get_remote_sha("ices-tools-prod", "icesTAF",

get_remote_sha <- function(username, repo, ref)
{
  ## GitHub API URL to get head commit at a reference
  url <- paste("https://api.github.com/repos", username, repo, "commits",
               URLencode(ref, reserved=TRUE), sep="/")
  ## Download JSON contents to temporary file
  tmp <- tempfile()
  on.exit(unlink(tmp), add=TRUE)
  download.file(url, tmp, quiet=TRUE)
  res <- read_json(tmp)
  res$sha
}
