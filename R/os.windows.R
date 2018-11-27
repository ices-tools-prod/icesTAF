#' @rdname os.unix
#'
#' @export

os.windows <- function()
{
  .Platform$OS.type == "windows"
}
