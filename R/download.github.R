#' Download GitHub Repository
#'
#' Download a repository from GitHub in \file{tar.gz} format.
#'
#' @param repo GitHub reference of the form \verb{owner/repo[/subdir]@ref}.
#' @param dir directory to download to.
#' @param quiet whether to suppress messages.
#'
#' @return Name of downloaded \verb{tar.gz} file.
#'
#' @note
#' In general, TAF scripts do not access the internet using
#' \code{download.github} or similar functions. Instead, data and software are
#' declared in \verb{DATA.bib} and \verb{SOFTWARE.bib} and then downloaded using
#' \code{\link{taf.bootstrap}}. The exception is when a bootstrap script is used
#' to fetch files from a web service (see
#' \href{https://github.com/ices-taf/doc/wiki/Bib-entries}{TAF Wiki}).
#'
#' @seealso
#' \code{\link{taf.bootstrap}} uses \code{download.github} to fetch software and
#' data repositories.
#'
#' \code{\link{download}} downloads a file.
#'
#' \code{\link{untar}} extracts a \verb{tar.gz} archive.
#'
#' \code{\link{taf.install}} installs a package in \verb{tar.gz} format.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' # Specify release tag
#' download.github("ices-tools-prod/icesTAF@2.0-0")
#'
#' # Specify SHA reference code
#' download.github("ices-tools-prod/icesTAF@d5a8947")
#' }
#'
#' @importFrom utils tar untar
#'
#' @export

download.github <- function(repo, dir=".", quiet=FALSE)
{
  mkdir(dir)  # bootstrap/software
  owd <- setwd(dir); on.exit(setwd(owd))

  if(!grepl("@", repo))
    repo <- paste0(repo, "@master")

  ## 1  Parse repo string
  spec <- parse.repo(repo)
  sha.full <- get.remote.sha(spec$username, spec$repo, spec$ref, seven=FALSE)
  sha <- substring(sha.full, 1, 7)
  url <- paste0("https://api.github.com/repos/",
                spec$username, "/", spec$repo, "/tarball/", spec$ref)
  targz <- paste0(spec$repo, "_", sha, ".tar.gz")  # repo_sha.tar.gz
  subdir <- spec$subdir
  subtargz <- paste0(subdir, "_", sha, ".tar.gz")  # subdir_sha.tar.gz

  ## 2  Download
  if(subdir=="" && file.exists(targz))  # no subdir, targz exists
  {
    if(!quiet)
      message("  Skipping download of '", targz, "' (already in place).")
  }
  else if(subdir!="" && file.exists(subtargz))  # subdir, subtargz exists
  {
    if(!quiet)
      message("  Skipping download of '", subtargz, "' (already in place).")
  }
  else
  {
    suppressWarnings(download(url, destfile=targz, quiet=quiet))
    if(subdir != "")
      extract.subdir(targz, subtargz, subdir)
  }

  outfile <- if(subdir == "") targz else subtargz

  ## 3  Add entries to DESCRIPTION file if we downloaded an R package
  if(basename(getwd()) == "software")
  {
    if(is.r.package(outfile, spec=spec))
      stamp.description(outfile, spec, sha.full)
  }

  invisible(outfile)
}

#' @rdname icesTAF-internal
#'
#' @importFrom utils packageDescription untar
#'
#' @export

## Extract subdir from bigger repo

extract.subdir <- function(targz, subtargz, subdir)
{
  repdir <- sub("/.*", "", untar(targz,list=TRUE)[1])  # top dir inside targz
  unlink(repdir, recursive=TRUE)  # remove folder if it already exists

  ## Sometimes the repo and subdir have the same name
  if(repdir != subdir)  # if repdir == subdir, then we have already
  {                     # downloaded this package and extracted the subdir
    untar(targz, file.path(repdir, subdir)) # extract subdir
    file.remove(targz)

    ## Move bootstrap/software/repdir/subdir to bootstrap/software/subdir
    file.rename(file.path(repdir, subdir), subdir)
    rmdir(repdir)

    ## Compress subdir as subdir_sha.tar.gz
    tar(subtargz, subdir, compression="gzip")
    unlink(subdir, recursive=TRUE, force=TRUE)
  }
}

#' @rdname icesTAF-internal
#'
#' @importFrom utils tar untar
#'
#' @export

## Add entries to DESCRIPTION file

stamp.description <- function(targz, spec, sha.full)
{
  pkg <- sub("/.*", "", untar(targz,list=TRUE)[1])
  unlink(pkg, recursive=TRUE)  # remove folder if it already exists
  untar(targz)

  desc <- read.dcf(file.path(pkg, "DESCRIPTION"), all=TRUE)
  desc$RemoteType <- "github"
  desc$RemoteHost <- "api.github.com"
  desc$RemoteRepo <- spec$repo
  desc$RemoteUsername <- spec$username
  desc$RemoteRef <- spec$ref
  desc$RemoteSha <- sha.full
  desc$RemoteSubdir <- if(spec$subdir == "") NULL else spec$subdir
  desc$GithubRepo <- spec$repo
  desc$GithubUsername <- spec$username
  desc$GithubRef <- spec$ref
  desc$GithubSHA1 <- sha.full
  desc$GithubSubdir <- if(spec$subdir == "") NULL else spec$subdir
  write.dcf(desc, file.path(pkg, "DESCRIPTION"))

  tar(targz, pkg, compression="gzip")
  unlink(pkg, recursive=TRUE)
}
