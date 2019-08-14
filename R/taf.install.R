#' TAF Install
#'
#' Install package in \file{tar.gz} format in local TAF library.
#'
#' @param targz package filename, see example.
#' @param lib location of local TAF library.
#' @param quiet whether to suppress messages.
#'
#' @note
#' After installing the package, this function writes the remote SHA reference
#' code into the package files \verb{DESCRIPTION} and \verb{Meta/package.rds}.
#'
#' @seealso
#' \code{\link{taf.bootstrap}} calls \code{taf.install} to install R packages,
#' via \code{\link{process.bib}}.
#'
#' \code{\link{download.github}} downloads a GitHub repository, for example a
#' package.
#'
#' \code{\link{install.packages}} is the underlying base function to install a
#' package.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' taf.install("bootstrap/software/FLAssess_f1e5acb.tar.gz")
#' }
#'
#' @importFrom tools file_path_sans_ext
#' @importFrom utils install.packages
#'
#' @export

taf.install <- function(targz, lib="bootstrap/library", quiet=FALSE)
{
  mkdir(lib)

  pkg <- sub(".*/(.*)_.*", "\\1", targz)     # path/pkg_sha.tar.gz -> pkg
  sha <- sub(".*_(.*?)\\..*", "\\1", targz)  # path/pkg_sha.tar.gz -> sha

  if(already.in.taf.library(targz,lib) && !quiet)
  {
    message("Skipping install of '", pkg, "'.")
    message("  Version '", sha, "' is already in ", lib, ".")
  }
  else
  {
    install.packages(targz, lib=lib, repos=NULL, quiet=quiet)
    ## Store RemoteSha in DESCRIPTION
    desc <- read.dcf(file.path(lib, pkg, "DESCRIPTION"), all=TRUE)
    desc$RemoteSha <- sha
    write.dcf(desc, file.path(lib, pkg, "DESCRIPTION"))
    ## Store RemoteSha in package.rds
    meta <- readRDS(file.path(lib, pkg, "Meta/package.rds"))
    meta$DESCRIPTION["RemoteSha"] <- sha
    saveRDS(meta, file.path(lib, pkg, "Meta/package.rds"))
  }
}

## Check whether requested package is already installed in the TAF library

#' @importFrom utils packageDescription

already.in.taf.library <- function(targz, lib)
{
  pkg <- sub(".*/(.*)_.*", "\\1", targz)
  sha.tar <- sub(".*_(.*?)\\..*", "\\1", targz)

  sha.inst <- if(pkg %in% dir(lib))
                packageDescription(pkg, lib.loc=lib)$RemoteSha else NULL
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
