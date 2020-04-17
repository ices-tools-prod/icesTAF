#' Clean Data
#'
#' Selectively remove data from the \verb{bootstrap/data} folder if not listed
#' in \verb{DATA.bib}.
#'
#' @param folder location of \verb{bootstrap/data}.
#' @param quiet whether to suppress messages about removed data.
#' @param force whether to remove \verb{folder}, regardless of how it compares
#'        to \verb{DATA.bib} entries.
#'
#' @note
#' For each data file or subfolder, the cleaning procedure selects between two
#' cases:
#' \enumerate{
#' \item Data entry found in \verb{DATA.bib} - do nothing.
#' \item Data entry is not listed in \verb{DATA.bib} - remove.
#' }
#'
#' The \code{taf.bootstrap} procedure cleans the \verb{bootstrap/data} folder,
#' without requiring the user to run \code{clean.data}.
#'
#' @seealso
#' \code{\link{taf.bootstrap}} calls \code{clean.data} as part of the default
#' bootstrap procedure.
#'
#' \code{\link{clean.software}} cleans the local TAF software folder.
#'
#' \code{\link{clean.library}} cleans the local TAF library.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' clean.data()
#' }
#'
#' @importFrom bibtex read.bib
#'
#' @export

clean.data <- function(folder="bootstrap/data", quiet=FALSE, force=FALSE)
{
  if(!file.exists(file.path(folder, "../DATA.bib")) || force)
  {
    unlink(folder, recursive=TRUE)
  }
  else
  {
    bib <- read.bib(file.path(folder, "../DATA.bib"))
    for(dat in dir(folder))
    {
      if(!(dat %in% names(bib)))
      {
        unlink(file.path(folder, dat), recursive=TRUE)
        if(!quiet)
          message("  cleaned ", file.path(folder, dat))
      }
    }
  }
  rmdir(folder)
}
