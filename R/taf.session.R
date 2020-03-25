#' @rdname icesTAF-internal
#'
#' @importFrom utils sessionInfo
#' @importFrom stats setNames
#'
#' @export

## Session info with RemoteSha

taf.session <- function(sort=TRUE)
{
  info <- function(desc)
  {
    lib <- dirname(find.package(desc$Package))
    desc$Library <- if(basename(dirname(lib)) == "bootstrap")
                      "TAF" else paste0("[", match(lib, .libPaths()), "]")
    desc$RemoteSha <- if(is.null(desc$RemoteSha))
                        "" else substring(desc$RemoteSha, 1, 7)
    fields <- c("Package", "Version", "Library", "RemoteSha")
    if(identical(desc$Priority, "base"))
      setNames(rep(NA_character_, 4), fields)
    else
      unlist(desc[fields])
  }

  si <- sessionInfo()

  pkgs <- sapply(c(si$otherPkgs, si$loadedOnly), info)
  pkgs <- pkgs[,apply(pkgs, 2, function(x) !all(is.na(x)))]
  pkgs <- data.frame(t(pkgs), row.names=NULL)
  if(sort)
    pkgs <- data.frame(pkgs[order(pkgs$Package),], row.names=NULL)

  pkgs
}
