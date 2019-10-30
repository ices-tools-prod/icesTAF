#' TAF Install
#'
#' Install packages in \file{tar.gz} format in local TAF library.
#'
#' @param targz a package filename, vector of filenames, or \code{NULL}.
#' @param lib location of local TAF library.
#' @param quiet whether to suppress messages.
#'
#' @details
#' If \verb{targz = NULL}, all packages found in \verb{bootstrap/software} are
#' installed, as long as they have filenames of the form
#' \verb{package_sha.tar.gz} containing a 7-character SHA reference code.
#'
#' The default behavior of \code{taf.install} is to install packages in
#' alphabetical order. When the installation order matters because of
#' dependencies, the user can specify a vector of package filenames to install.
#'
#' @note
#' The \code{taf.bootstrap} procedure downloads and installs R packages, without
#' requiring the user to run \code{taf.install}. The main reason for a TAF user
#' to run \code{taf.install} directly is to initialize and run a TAF analysis
#' without running the bootstrap procedure, e.g. to avoid updating the
#' underlying datasets and software.
#'
#' After installing the package, this function writes the remote SHA reference
#' code into the package files \verb{DESCRIPTION} and \verb{Meta/package.rds}.
#'
#' @seealso
#' \code{\link{taf.bootstrap}} calls \code{\link{download.github}} and
#' \code{taf.install} to download and install R packages, via
#' \code{\link{process.bib}}.
#'
#' \code{\link{clean.library}} selectively removes packages from the local TAF
#' library.
#'
#' \code{\link{install.packages}} is the underlying base function to install a
#' package.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' # Install one package
#' taf.install("bootstrap/software/FLAssess_f1e5acb.tar.gz")
#'
#' # Install all packages found in bootstrap/software
#' taf.install()
#' }
#'
#' @importFrom tools file_path_sans_ext
#' @importFrom utils install.packages
#'
#' @export

taf.install <- function(targz=NULL, lib="bootstrap/library", quiet=FALSE)
{
  if(is.null(targz))
    targz <- dir("bootstrap/software", pattern="_[0-9a-f]{7}\\.tar\\.gz",
                 full.names=TRUE)

  mkdir(lib)

  for(tgz in targz)
  {
    pkg <- sub(".*/(.*)_.*", "\\1", tgz)     # path/pkg_sha.tar.gz -> pkg
    sha <- sub(".*_(.*?)\\..*", "\\1", tgz)  # path/pkg_sha.tar.gz -> sha

    if(already.in.taf.library(tgz, lib))
    {
      if(!quiet)
      {
        message("Skipping install of '", pkg, "'.")
        message("  Version '", sha, "' is already in ", lib, ".")
      }
    }
    else
    {
      install.packages(tgz, lib=lib, repos=NULL, quiet=quiet)
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
  ## Read and extract SHA code
  sha <- readLines(url, n=2)[2]
  sha <- sub("  \"sha\": \"(.*)\",", "\\1", sha)
  sha
}
