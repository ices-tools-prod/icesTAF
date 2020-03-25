#' @rdname icesTAF-internal
#'
#' @export

## Add "bootstrap/library" to the search path for R packages

taf.libPaths <- function()
{
  .libPaths(c("bootstrap/library", .libPaths()))
}
