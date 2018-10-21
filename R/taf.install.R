#' Install Package from GitHub into TAF Library
#'
#' Install an R package that is hosted on GitHub. The package is installed into
#' a local TAF library \file{bootstrap/library} within the assessment directory
#' tree.
#'
#' @param owner GitHub user name or organization hosting the repository.
#' @param repo GitHub repository name.
#' @param ref reference, preferably a tag, release, or 40-character SHA-1 hash.
#' @param subdir subdirectory containing the R package, if it's not at the top
#'        level of the repository.
#'
#' @note
#' A fixed reference such as a tag, release, or 40-character SHA-1 hash is
#' recommended. Branch names, such as \code{"master"}, are pointers that are
#' subject to change, and are therefore not reliable as long-term references.
#'
#' This function is not intended as a replacement for the \code{install_github}
#' function found in the \pkg{devtools} package. Rather, it serves as a
#' reference tool to support long-term reproducibility of TAF assessments,
#' without adding \pkg{devtools} and its underlying packages as dependencies.
#'
#' The TAF library is intended for R packages that are not archived on CRAN.
#'
#' @seealso
#' \code{\link{install.packages}} is the underlying base function that installs
#' the package after downloading from GitHub.
#'
#' \code{\link[devtools]{install_github}} is a commonly used function to install
#' packages from GitHub.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' # Installing the tagged release 1.0-0
#' taf.install("ices-tools-prod", "icesTAF", "1.0-0")
#'
#' # is equivalent to the SHA-1 hash
#' taf.install("ices-tools-prod", "icesTAF",
#'             "69beeb4300453d93a10a5a35142775119df7da66")
#' }
#'
#' @importFrom tools file_path_sans_ext
#' @importFrom utils install.packages untar
#'
#' @export

taf.install <- function(owner, repo, ref, subdir="")
{
  ## 1  Make sure directories exist
  mkdir("bootstrap/packages")
  mkdir("bootstrap/library")

  ## 2  Add TAF library to search path
  .libPaths(unique(c("bootstrap/library", .libPaths())))

  ## 3  Download repo as tar.gz
  url <- paste("https://codeload.github.com", owner, repo,
               "legacy.tar.gz", ref, sep="/")
  tar.gz <- paste0("bootstrap/packages/", owner, "-", repo,
                   "-", substring(ref,1,7), ".tar.gz")
  download(url, destfile=tar.gz)

  ## 4  Install, either from tar.gz or subdir
  if(subdir == "")
  {
    install.packages(tar.gz, lib="bootstrap/library", repos=NULL)
  }
  else
  {
    untar(tar.gz, exdir="bootstrap/packages")
    pkg <- file.path(file_path_sans_ext(tar.gz,compression=TRUE), subdir)
    install.packages(pkg, lib="bootstrap/library", repos=NULL)
    unlink(file_path_sans_ext(tar.gz,compression=TRUE), recursive=TRUE)
  }
}
