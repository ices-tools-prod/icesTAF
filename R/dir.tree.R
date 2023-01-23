#' Print a directory tree
#'
#' Print the directory tree and file contents in a pretty way
#'
#' @param path the directory for which the listing is to be shown
#'
#' @seealso
#'
#' \link{list.files}
#'
#' @examples
#' \dontrun{
#'
#' library(icesTAF)
#'
#' # Download a TAF analysis
#' dir.tree()
#' }
#'
#' @importFrom data.tree as.Node
#'
#' @export

dir.tree <- function(path = ".") {
  # get skeleton path structure
  paths <-
    list.files(
      path,
      recursive = TRUE, full.names = TRUE, include.dirs = TRUE
    )

  # make a data.tree and print it
  tree <- as.Node(data.frame(pathString = paths))
  tree <- as.data.frame(tree)
  names(tree) <- ""

  print(
    tree,
    row.names = FALSE
  )
}
