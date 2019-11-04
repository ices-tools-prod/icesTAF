## Get the SHA code of the remote for a given reference

#' @importFrom utils URLencode download.file

## Internal use examples:
## icesTAF:::get.remote.sha("ices-tools-prod", "icesTAF", "master")
## icesTAF:::get.remote.sha("ices-tools-prod", "icesTAF", "3.1-1")
## icesTAF:::get.remote.sha("ices-tools-prod", "icesTAF",

get.remote.sha <- function(username, repo, ref, seven=TRUE)
{
  ## GitHub API URL to get head commit at a reference
  url <- paste("https://api.github.com/repos", username, repo, "commits",
               URLencode(ref, reserved=TRUE), sep="/")
  ## Read and extract SHA code
  sha <- readLines(url, n=2)[2]
  sha <- sub("  \"sha\": \"(.*)\",", "\\1", sha)
  ## Truncate to seven characters
  if(seven)
    sha <- substring(sha, 1, 7)

  sha
}
