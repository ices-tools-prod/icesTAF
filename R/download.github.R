# Download GitHub Repository
#'
#' Download a repository from GitHub in \file{tar.gz} format.
#'
#' @param repo GitHub reference of the form \verb{owner/repo[/subdir]@ref}.
#' @param dir directory to download to.
#'
#' @note
#' In general, TAF scripts do not access the internet using
#' \code{download.github} or similar functions. Instead, data and software are
#' declared in \file{DATA.bib} and \file{SOFTWARE.bib} and then downloaded using
#' \code{\link{taf.bootstrap}}. The exception is when a bootstrap data script is
#' used to fetch data files from a web service (see \code{\link{process.bib}}).
#'
#' @seealso
#' \code{\link{download}} downloads a file.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' download.github("ices-tools-prod/icesTAF@2.0-0")
#' }
#'
#' @importFrom remotes parse_repo_spec
#'
#' @export

download.github <- function(repo, dir=".")
{
  mkdir(dir)
  spec <- parse_repo_spec(repo)
  sha <- get_remote_sha(spec$username, spec$repo, spec$ref)  # branch -> sha
  spec$ref <- substring(sha, 1, 7)
  url <- paste0("https://api.github.com/repos/",
                spec$username, "/", spec$repo, "/tarball/", spec$ref)
  targz <- paste0(spec$repo, "_", spec$ref, ".tar.gz")
  if(!file.exists(file.path(dir, targz)))
    suppressWarnings(download(url, destfile=file.path(dir, targz)))
}
