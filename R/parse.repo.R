#' @rdname icesTAF-internal
#'
#' @importFrom utils head tail
#'
#' @export

## Split repo string, without depending on 'remotes' package

parse.repo <- function(repo)
{
  x <- unlist(strsplit(repo, "/"))

  username <- head(x, 1)
  repo.ref <- tail(x, 1)
  subdir <- if(length(x) == 2) "" else unlist(strsplit(x[3], "@"))[1]

  repo <- if(length(x) == 2) unlist(strsplit(repo.ref, "@"))[1] else x[2]
  ref <- if(grepl("@", repo.ref)) unlist(strsplit(repo.ref, "@"))[2] else ""

  list(username=username, repo=repo, subdir=subdir, ref=ref)
}
