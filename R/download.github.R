#' Download GitHub Repository
#'
#' Download a repository from GitHub in \file{tar.gz} format.
#'
#' @param repo GitHub reference of the form \verb{owner/repo[/subdir]@ref}.
#' @param dir directory to download to.
#' @param quiet whether to suppress messages.
#'
#' @note
#' In general, TAF scripts do not access the internet using
#' \code{download.github} or similar functions. Instead, data and software are
#' declared in \file{DATA.bib} and \file{SOFTWARE.bib} and then downloaded using
#' \code{\link{taf.bootstrap}}. The exception is when a bootstrap data script is
#' used to fetch data files from a web service (see \code{\link{process.bib}}).
#'
#' @seealso
#' \code{\link{taf.bootstrap}} calls \code{download.github} to fetch software
#' and data repositories, via \code{\link{process.bib}}.
#'
#' \code{\link{download}} downloads a file.
#'
#' \code{\link{untar}} extracts a \verb{tar.gz} archive.
#'
#' \code{\link{taf.install}} installs a package in \file{tar.gz} format.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' download.github("ices-tools-prod/icesTAF@2.0-0")
#' }
#'
#' @importFrom remotes parse_repo_spec
#' @importFrom utils tar untar
#'
#' @export

download.github <- function(repo, dir=".", quiet=TRUE)
{
  mkdir(dir)  # bootstrap/software
  owd <- setwd(dir); on.exit(setwd(owd))

  if(!grepl("@", repo))
    repo <- paste0(repo, "@master")

  ## 1  Download
  spec <- parse_repo_spec(repo)
  sha <- get_remote_sha(spec$username, spec$repo, spec$ref)  # branch -> sha
  sha <- substring(sha, 1, 7)
  url <- paste0("https://api.github.com/repos/",
                spec$username, "/", spec$repo, "/tarball/", spec$ref)
  targz <- paste0(spec$repo, "_", sha, ".tar.gz")  # repo_sha.tar.gz
  if(!file.exists(targz))
    suppressWarnings(download(url, destfile=targz, quiet=quiet))

  ## 2  Handle subdir
  if(spec$subdir != "")
  {
    repdir <- basename(untar(targz, list=TRUE)[1])  # top directory inside targz
    subdir <- spec$subdir
    untar(targz, file.path(repdir, subdir)) # extract subdir
    file.remove(targz)
    ## Move bootstrap/software/repdir/subdir to bootstrap/software/subdir
    cp(file.path(repdir, subdir), ".", move=TRUE)
    rmdir(repdir)
    ## Compress subdir as subdir_sha.tar.gz
    subtargz <- paste0(subdir, "_", sha, ".tar.gz")
    tar(subtargz, subdir, compression="gzip")
    unlink(subdir, recursive=TRUE, force=TRUE)
  }
}
