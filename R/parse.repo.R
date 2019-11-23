#' @rdname icesTAF-internal
#'
#' @importFrom utils head tail
#'
#' @export

## split repo string

parse.repo <- function(repo)
{
  x <- unlist(strsplit(repo, "/"))

  username <- head(x, 1)
  repo.ref <- tail(x, 1)
  subdir <- if(length(x) == 2) "" else x[2]

  repo <- unlist(strsplit(repo.ref, "@"))[1]
  ref <- if(grepl("@", repo.ref)) unlist(strsplit(repo.ref, "@"))[2] else ""

  list(username=username, repo=repo, subdir=subdir, ref=ref)
}
