#' Get Remote SHA
#'
#' Look up SHA reference code on GitHub.
#'
#' @param owner repository owner.
#' @param repo repository name.
#' @param ref reference.
#' @param seven whether to truncate SHA reference code to seven characters.
#'
#' @return SHA reference code as a string.
#'
#' @seealso
#' \code{\link{taf.bootstrap}} uses \code{get.remote.sha} to determine whether
#' it is necessary to remove or download files, via \code{\link{clean.library}},
#' \code{\link{clean.software}}, and \code{\link{download.github}}.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' get.remote.sha("ices-tools-prod", "icesTAF", "master")
#' get.remote.sha("ices-tools-prod", "icesTAF", "3.0-0")
#' }
#'
#' @importFrom utils URLencode
#'
#' @export

get.remote.sha <- function(owner, repo, ref, seven=TRUE)
{
  ## GitHub API URL to get head commit at a reference
  url <- paste("https://api.github.com/repos", owner, repo, "commits",
               URLencode(ref,reserved=TRUE), sep="/")
  ## Read and extract SHA code
  sha <- readLines(url, n=2)[2]
  sha <- sub("  \"sha\": \"(.*)\",", "\\1", sha)
  ## Truncate to seven characters
  if(seven)
    sha <- substring(sha, 1, 7)

  sha
}
