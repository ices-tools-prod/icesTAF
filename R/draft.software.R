#' Draft SOFTWARE.bib
#'
#' Create an initial draft version of a \file{SOFTWARE.bib} metadata file.
#'
#' @param package name of one or more installed R packages, or files/folders
#'        inside \file{bootstrap/initial/software}.
#' @param author author(s) of the software.
#' @param year year when this version of the software was released, or the
#'        publication year of the cited manual/article/etc.
#' @param title title or short description of the software.
#' @param version string to specify details about the version, e.g. GitHub
#'        branch and commit date.
#' @param source string to specify where the software are copied/downloaded
#'        from. This can be a GitHub reference of the form
#'        \verb{owner/repo[/subdir]@ref}, URL, or a filename.
#' @param file optional filename to save the draft metadata to a file.
#' @param append whether to append metadata entries to an existing file.
#'
#' @details
#' Typical usage is to specify \code{package}, while using the default values
#' for the other arguments.
#'
#' With the default \verb{version = NULL}, the function will automatically
#' suggest an appropriate version entry for CRAN packages, but for GitHub
#' packages it is left to the user to add further information about the GitHub
#' branch (if different from \verb{master}) and the commit date.
#'
#' With the default \verb{source = NULL}, the function will automatically
#' suggest an appropriate source entry for CRAN and GitHub packages, but for
#' other R packages it is left to the user to add information about where the
#' software can be accessed.
#'
#' The default value \code{file = ""} prints the initial draft in the console,
#' instead of writing it to a file. The output can then be pasted into a file to
#' edit further, without accidentally overwriting an existing metadata file.
#'
#' @return
#' Object of class \verb{Bibtex}.
#'
#' @note
#' After creating the initial draft, the user can complete the \verb{version},
#' \verb{source}, and other fields as required.
#'
#' This function is especially useful for citing exact versions of R packages on
#' GitHub. To prepare metadata for software other than R packages, see the
#' \code{\link{process.bib}} help page for an example.
#'
#' @seealso
#' \code{\link{citation}} and \code{\link{packageDescription}} are the
#' underlying functions to access information about installed R packages.
#'
#' \code{\link{draft.data}} creates an initial draft version of a
#' \file{DATA.bib} metadata file.
#'
#' \code{\link{process.bib}} reads and processes metadata entries.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' # Print in console
#' draft.software("icesTAF")
#'
#' \dontrun{
#' # Export to file
#' draft.software("icesTAF", file="bootstrap/SOFTWARE.bib")
#' }
#'
#' @export

draft.software <- function(package, author=NULL, year=NULL, title=NULL,
                           version=NULL, source=NULL, file="", append=FALSE)
{
  if(length(package) > 1)
  {
    ## Process many packages - mapply requires conversion of NULL to NA
    author <- if(is.null(author)) NA else author
    year <- if(is.null(year)) NA else year
    title <- if(is.null(title)) NA else title
    version <- if(is.null(version)) NA else version
    source <- if(is.null(source)) NA else source
    z <- mapply(draft.software, package=package, author=author, year=year,
                title=title, version=version, source=source, SIMPLIFY=FALSE)
    out <- list()
    ## Add newline between entries
    for(i in seq_along(z))
    {
      out[[2*i-1]] <- z[[i]]
      out[[2*i]] <- ""
    }
    out <- unlist(out)
    out <- out[-length(out)] # remove empty line at end
    class(out) <- "Bibtex"
  }
  else if(dirname(package) == "bootstrap/initial/software")
  {
    out <- ds.file(package=package, author=author, year=year, title=title,
                   version=version, source=source)
  }
  else
  {
    out <- ds.package(package=package, author=author, year=year, title=title,
                      version=version, source=source)
  }

  ## No write() when file="", to ensure quiet assignment x <- draft.software()
  if(file == "")
  {
    out
  }
  else
  {
    if(append)
      write("", file=file, append=TRUE)  # empty line separator
    write(out, file=file, append=append)
    invisible(out)
  }
}
