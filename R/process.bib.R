#' Process Metadata
#'
#' Read and process metadata entries in a \verb{*.bib} file.
#'
#' @param bibfile metadata file to process, either \code{"DATA.bib"} or
#'        \code{"SOFTWARE.bib"}.
#'
#' @note
#' This is a helper function for \code{\link{taf.bootstrap}} and can also be
#' used in a custom \verb{bootstrap.R} script. It should be called within the
#' \file{bootstrap} directory that contains the metadata file.
#'
#' Within each metadata entry, the \dfn{source} field specifies where data or
#' software originate from. There are four types of values that can be used in
#' the source field:
#' \enumerate{
#' \item GitHub reference of the form \verb{owner/repo[/subdir]@ref},
#'       identifying a specific version of an R package. A fixed reference such
#'       as a tag, release, or SHA-1 hash is recommended. Branch names, such as
#'       \verb{master}, are pointers that are subject to change, and are
#'       therefore not reliable as long-term references.
#' \item URL starting with \verb{http} or \verb{https}, identifying a file to
#'       download.
#' \item Relative path starting with \file{initial}, identifying the location of
#'       a file or folder provided by the user.
#' \item Special value \code{file}, indicating that the metadata key points to a
#'       file location.
#' }
#'
#' Consider, for example, the following metadata entry from a \verb{DATA.bib}
#' file:
#' \preformatted{@Misc{PLE7DFleet_2016.txt,
#'   originator = {WGNSSK},
#'   year       = {2016},
#'   title      = {Survey indices: UK_BTS, FR_GFS, IN_YFS},
#'   period     = {1987-2015},
#'   source     = {file},
#' }}
#' Here, a data file is described using the \verb{@Misc} entry type and the
#' string following the entry type is called a \dfn{key}. The next fields state
#' that this file was prepared by the North Sea working group in 2016 and it
#' contains survey indices from 1987 to 2015. It is not necessary to specify the
#' stock name, since that will be automatically recorded on the TAF server. The
#' special value \verb{source = {file}} means that the key, in this case
#' \verb{PLE7DFleet_2016.txt}, is the name of the file located inside
#' \verb{bootstrap/initial/data}. This \verb{file} shorthand notation is
#' equivalent to specifying the relative path:
#' \verb{source = {initial/data/PLE7DFleet_2016.txt}}.
#'
#' Another example metadata entry is from a \verb{SOFTWARE.bib} file:
#' \preformatted{@Manual{FLAssess,
#'   author  = {Laurence T Kell},
#'   year    = {2018},
#'   title   = {{FLAssess}: Generic classes and methods for stock assessment
#'              models},
#'   version = {2.6.2, released 2018-07-18},
#'   source  = {flr/FLAssess@v2.6.2},
#' }}
#' This entry describes a specific version of an R package that is required for
#' the TAF analysis. It is similar, but not identical, to the output from the R
#' command \verb{citation("FLAssess")}. The version field specifies the version
#' number and release date, with a corresponding GitHub reference. When an R
#' package is not an official release but a development version, the version and
#' source may look like this,
#' \preformatted{  version = {2.6.3, committed 2018-10-09},
#'   source  = {flr/FLAssess@f1e5acb},}
#' or this:
#' \preformatted{  version = {0.5.4 components branch, committed 2018-03-12},
#'   source  = {fishfollower/SAM/stockassessment@25b3591},}
#' For development versions like these, the version number itself may not be
#' important or accurate, but the branch name and commit date may be
#' informative. The 7-character SHA reference code is a pointer to the exact
#' version of the package required for the analysis.
#'
#' As a final metadata example, we look at a software entry that is not an R
#' package. It is made available as a zip archive, containing the model source
#' code (sole.tpl) and executables for different platforms (sole, sole.exe). The
#' model does not have an explicit version number, so the \verb{version} field
#' contains the year in which the model is used, along with the date when the
#' source code was last modified:
#' \preformatted{@Article{sole,
#'   author  = {G. Aarts and J.J. Poos},
#'   year    = {2009},
#'   title   = {Comprehensive discard reconstruction and abundance estimation
#'              using flexible selectivity functions},
#'   journal = {ICES Journal of Marine Science},
#'   volume  = {66},
#'   pages   = {763-771},
#'   doi     = {10.1093/icesjms/fsp033},
#'   version = {2016, last modified 2016-04-27},
#'   source  = {initial/software/sole.zip},
#' }}
#'
#' In summary, the metadata are similar to bibliographic entries, with the
#' important addition of source directives that guide the bootstrap procedure to
#' set up data files and software.
#'
#' @seealso
#' \code{\link{taf.bootstrap}} calls \code{process.bib} to process metadata.
#'
#' \code{\link{draft.data}} and \code{\link{draft.software}} can be used to
#' create initial draft versions of \file{DATA.bib} and \file{SOFTWARE.bib}
#' metadata files.
#'
#' \code{\link{period}} pastes two years to form a \code{period} string.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' process.bib("DATA.bib")
#' process.bib("SOFTWARE.bib")
#' }
#'
#' @importFrom bibtex read.bib
#' @importFrom remotes install_github parse_repo_spec
#'
#' @export

process.bib <- function(bibfile)
{
  type <- if(bibfile == "DATA.bib") "data"
          else if(bibfile == "SOFTWARE.bib") "software"
          else stop("bibfile must be 'DATA.bib' or 'SOFTWARE.bib'")

  entries <- if(file.exists(bibfile)) read.bib(bibfile) else list()

  for(bib in entries)
  {
    ## Prepare dir
    dir <- if(is.null(bib$bundle)) type else file.path(type, bib$bundle)
    mkdir(dir)

    ## If source contains multiple files then split into vector
    bib$source <- trimws(unlist(strsplit(bib$source, "\\n")))
    bib$source <- sub(",$", "", bib$source)  # remove trailing comma

    ## Add prefix
    bib$source <- paste0(bib$prefix, bib$source)

    ## Case 1: R package on GitHub
    if(grepl("@", bib$source[1]))
    {
      spec <- parse_repo_spec(bib$source)
      url <- paste0("https://api.github.com/repos/",
                    spec$username, "/", spec$repo, "/tarball/", spec$ref)
      targz <- paste0(spec$repo, "_", spec$ref, ".tar.gz")
      if(!file.exists(file.path(dir, targz)))
        suppressWarnings(download(url, destfile=file.path(dir, targz)))
      mkdir("library")
      ## Need to check manually and force=TRUE, since the install_github()
      ## built-in checks get confused if package is installed in another library
      if(already.in.taf.library(spec))
      {
        pkg <- basename(file.path(spec$repo, spec$subdir))
        message("Skipping install of '", pkg, "'.")
        message("  Version '", spec$ref,
                "' is already in the local TAF library.")
      }
      else
      {
        install_github(bib$source, lib="library", dependencies=FALSE,
                       upgrade=FALSE, force=TRUE)
      }
    }
    ## Case 2: File to download
    else if(grepl("^http", bib$source[1]))
    {
      sapply(bib$source, download, dir=dir)
    }
    ## Case 3: File to copy
    else
    {
      ## Shorthand notation: source = {file} means key is a filename
      if(bib$source[1] == "file")
        bib$source[1] <- file.path("initial", dir, attr(bib,"key"))
      sapply(bib$source, cp, to=dir)
    }
  }
}

## Check whether requested package is already installed in the TAF library

#' @importFrom utils installed.packages packageDescription

already.in.taf.library <- function(spec)
{
  pkg <- basename(file.path(spec$repo, spec$subdir))
  sha.bib <- spec$ref
  sha.inst <- if(pkg %in% row.names(installed.packages("library")))
                packageDescription(pkg, "library")$RemoteSha else NULL
  sha.inst <- substring(sha.inst, 1, nchar(sha.bib))
  out <- identical(sha.bib, sha.inst)
  out
}
