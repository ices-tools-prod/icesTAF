#' @rdname taf.unix
#'
#' @export

taf.windows <- function()
{
  .Platform$OS.type == "windows"
}
