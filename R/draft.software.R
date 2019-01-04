#' Draft SOFTWARE.bib
#'
#' Create an initial draft version of a \file{SOFTWARE.bib} metadata file.
#'
#' @param package name of an installed R package.
#' @param version optional string to specify details about the version, e.g.
#'        GitHub branch and commit date.
#' @param source optional string to specify where the software can be accessed.
#'        This can be a GitHub reference of the form
#'        \verb{owner/repo[/subdir]@ref}, URL, or a filename.
#' @param file optional filename to save the draft metadata to a file.
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
#' other packages it is left to the user to add further information about where
#' the software can be accessed.
#'
#' The default value \code{file = ""} prints the initial draft in the console,
#' instead of writing it to a file. The output can then be pasted into a file to
#' edit further, without accidentally overwriting an existing metadata file.
#'
#' @return
#' Object of class \verb{Bibtex} that can be copied from the console or exported
#' to file using \code{writeLines}.
#'
#' @note
#' After creating the initial draft, the user can complete the \verb{version}
#' and \verb{source} fields as required.
#'
#' This function only handles R packages. To prepare metadata for other
#' software, see the \code{\link{process.bib}} help page for an example.
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
#' draft.software("icesTAF", file="bootstrap/SOFTWARE-draft.bib")
#' }
#'
#' @importFrom utils citation packageDescription toBibtex
#'
#' @export

draft.software <- function(package, version=NULL, source=NULL, file="")
{
  if(length(package) > 1)
  {
    ## Process many packages - mapply requires conversion of NULL to NA
    version <- if(is.null(version)) NA else version
    source <- if(is.null(source)) NA else source
    z <- mapply(draft.software, package, version=version,
                source=source, file="", SIMPLIFY=FALSE)
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
  else
  {
    ## 1  Bibliographic info: author, year, title, details
    bib <- as.list(toBibtex(citation(package)[1]))
    key <- sub(",$", paste0(package,","), bib[[1]])  # add package name
    bibtype <- tolower(sub("@(.*)\\{.*", "\\1", key))
    details <- switch(bibtype,
                      article=c(bib$journal, bib$volume, bib$number,
                                bib$pages, bib$doi),
                      book=c(bib$edition, bib$address, bib$publisher, bib$doi),
                      inbook=c(bib$edition, bib$address, bib$publisher,
                               bib$pages, bib$doi),
                      techreport=c(bib$institution, bib$edition,
                                   bib$number, bib$note, bib$doi),
                      thesis=c(bib$type, bib$school),
                      c(bib$edition, bib$doi))

    ## 2  Package info: version, source
    pkg <- packageDescription(package)
    repotype <- if(isTRUE(pkg$Repository == "CRAN")) "CRAN"
                else if(isTRUE(pkg$RemoteType == "github")) "GitHub"
                else if(!is.null(pkg$Repository)) pkg$Repository
                else NA_character_
    if(is.null(version) || is.na(version))  # catch NA from mapply
    {
      released <- if(isTRUE(repotype == "CRAN"))
                    paste(", released", substring(pkg$"Date/Publication",1,10))
      version <- paste0(pkg$Version, released)
    }
    version <- paste0("  version = {", version, "},")
    if(is.null(source) || is.na(source))  # catch NA from mapply
    {
      source <- switch(repotype,
                       CRAN=paste0("cran/", package, "@", pkg$Version),
                       GitHub=paste0(pkg$GithubUsername,
                                     "/", pkg$GithubRepo,
                                     if(!is.null(pkg$GithubSubdir))
                                       paste0("/", pkg$GithubSubdir),
                                     "@", substring(pkg$GithubSHA1, 1, 7)))
    }
    source <- paste0("  source = {", source, "},")

    ## 3  Combine and format metadata
    fields <- c(bib$author, bib$year, bib$title, details, version, source)
    fields <- strsplit(fields, "=")  # align at equals sign
    fields <- paste0(format(sapply(fields,"[",1)), "=", sapply(fields,"[",2))
    out <- c(key, fields, "}")
    class(out) <- "Bibtex"
  }

  ## 4  Export
  ## No write() when file="", to ensure quiet assignment x <- draft.software()
  if(file == "")
  {
    out
  }
  else
  {
    write(out, file=file)
    invisible(out)
  }
}
