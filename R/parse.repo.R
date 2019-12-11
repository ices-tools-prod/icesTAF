#' @rdname icesTAF-internal
#'
#' @importFrom utils head tail
#'
#' @export

## Split repo string, without depending on 'remotes' package

parse.repo <- function(repo)
{
  ## 1  Read ref, then remove @reference tail
  ref <- if(grepl("@",repo)) unlist(strsplit(repo,"@"))[2] else ""
  repo <- sub("@.*", "", repo)

  ## 2  Read username, repo, subdir
  x <- unlist(strsplit(repo, "/"))
  username <- x[1]
  repo <- x[2]
  subdir <- if(length(x) > 2) paste(x[-c(1,2)],collapse="/") else ""

  list(username=username, repo=repo, subdir=subdir, ref=ref)
}
