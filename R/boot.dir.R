#' @rdname icesTAF-internal
#'
#' @export

## Boot directory name

boot.dir <- function()
{
  if(dir.exists("boot"))
    out <- "boot"
  else if(dir.exists("bootstrap"))
    out <- "bootstrap"
  else
    out <- NULL
  out
}
