#' Process Metadata
#'
#' Read and process metadata entries in a \verb{*.bib} file.
#'
#' @param bibfile metadata file to process, either \code{"SOFTWARE.bib"} or
#'        \code{"DATA.bib"}.
#' @param clean whether to \code{\link{clean}} directories.
#' @param quiet whether to suppress messages reporting progress.
#'
#' @details
#' If \code{bibfile = "SOFTWARE.bib"} and \code{clean = TRUE}, then
#' \file{bootstrap/software} is cleaned with \code{\link{clean.software}} and
#' \file{bootstrap/library} is cleaned with \code{\link{clean.library}} before
#' processing metadata entries.
#'
#' If \code{bibfile = "DATA.bib"} and \code{clean = TRUE}, then the
#' \file{bootstrap/data} directory is cleaned before processing metadata
#' entries.
#'
#' @return \code{TRUE} for success.
#'
#' @note
#' This is a helper function for \code{\link{taf.bootstrap}}. It is called
#' within the \file{bootstrap} directory that contains the metadata file.
#'
#' A metadata file contains one or more entries that use a general BibTeX
#' format:
#'
#' \preformatted{@Type{key,
#'   field = {value},
#'   ...,
#' }}
#'
#' Consider, for example, the following metadata entry from a \verb{DATA.bib}
#' file:
#'
#' \preformatted{@Misc{PLE7DFleet_2016.txt,
#'   originator = {WGNSSK},
#'   year       = {2016},
#'   title      = {Survey indices: UK_BTS, FR_GFS, IN_YFS},
#'   period     = {1987-2015},
#'   access     = {Public},
#'   source     = {file},
#' }}
#'
#' Here, a data file is described using the \verb{@Misc} entry type and the
#' string following the entry type is called a \dfn{key}. The next fields state
#' that this file was prepared by the North Sea working group in 2016, it
#' contains survey indices from 1987 to 2015, and access to this file is public.
#' It is not necessary to specify the stock name, since that will be
#' automatically recorded on the TAF server.
#'
#' The special value \verb{source = {file}} means that the key, in this case
#' \verb{PLE7DFleet_2016.txt}, is the name of the file located inside
#' \verb{bootstrap/initial/data}. This \verb{file} shorthand notation is
#' equivalent to specifying the relative path:
#' \verb{source = {initial/data/PLE7DFleet_2016.txt}}.
#'
#' The \dfn{source} field specifies where data or software originate from. The
#' following types of values can be used in the source field:
#'
#' \enumerate{
#' \item GitHub reference of the form \verb{owner/repo[/subdir]@ref},
#'       identifying a specific version of an R package. A fixed reference such
#'       as a tag, release, or SHA-1 hash is recommended. Branch names, such as
#'       \verb{master}, are pointers that are subject to change, and are
#'       therefore not reliable as long-term references.
#' \item URL starting with \verb{http} or \verb{https}, identifying a file to
#'       download.
#' \item Relative path starting with \file{initial}, identifying the location of
#'       a file or directory provided by the user.
#' \item Special value \code{file}, indicating that the metadata key points to a
#'       file location.
#' \item Special value \code{script}, indicating that a bootstrap data script
#'       should be run to fetch data files from a web service. The metadata key
#'       is used both to identify the script \file{bootstrap/\emph{key}.R} and
#'       target directory \file{bootstrap/data/\emph{key}}.
#' }
#'
#' Model settings can be stored in a file or folder inside
#' \verb{bootstrap/initial/data} and included as a simple \verb{DATA.bib} entry,
#' for example:
#'
#' \preformatted{@Misc{config,
#'   originator = {HAWG},
#'   year       = {2019},
#'   title      = {Model settings},
#'   source     = {file},
#' }}
#'
#' Another example metadata entry is from a \verb{SOFTWARE.bib} file:
#'
#' \preformatted{@Manual{FLAssess,
#'   author  = {Laurence T Kell},
#'   year    = {2018},
#'   title   = {{FLAssess}: Generic classes and methods for stock assessment
#'              models},
#'   version = {2.6.2, released 2018-07-18},
#'   source  = {flr/FLAssess@v2.6.2},
#' }}
#'
#' This entry describes a specific version of an R package that is required for
#' the TAF analysis. It is similar, but not identical, to the output from the R
#' command \verb{citation("FLAssess")}. The version field specifies the version
#' number and release date, with a corresponding GitHub reference. When an R
#' package is not an official release but a development version, the version and
#' source may look like this,
#'
#' \preformatted{  version = {2.6.3, committed 2018-10-09},
#'   source  = {flr/FLAssess@f1e5acb},}
#'
#' or this:
#'
#' \preformatted{  version = {0.5.4 components branch, committed 2018-03-12},
#'   source  = {fishfollower/SAM/stockassessment@25b3591},}
#'
#' For development versions like these, the version number itself may not be
#' important or accurate, but the branch name and commit date can be
#' informative. The 7-character SHA reference code is a pointer to the exact
#' version of the package required for the analysis.
#'
#' If software entry \emph{A} depends on entry \emph{B}, then \emph{B} should be
#' listed before \emph{A} in \verb{SOFTWARE.bib}, so they are installed in the
#' right order.
#'
#' As a final metadata example, we look at a software entry that is not an R
#' package. It is made available as a directory \file{sole} containing the model
#' source code (\verb{sole.tpl}) and executables for different platforms
#' (\verb{sole}, \verb{sole.exe}). The model does not have an explicit version
#' number, so the version field contains the year in which the model is used,
#' along with the date when the source code was last modified:
#'
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
#'   source  = {initial/software/sole},
#' }}
#'
#' The source field can specify multiple URLs to download, separated by
#' newlines. To shorten the source entries, the \dfn{prefix} field can be useful
#' to specify a prefix that is common for all source entries.
#'
#' The \dfn{dir} field is optional and creates a directory to place files in. If
#' the dir field is used, it can only have the value \verb{dir = {TRUE}} and the
#' resulting directory will be named after the metadata key. The dir field is
#' mainly useful when two or more data files that need to be downloaded have the
#' same name. It is implied and not necessary to set \verb{dir = TRUE} when
#' \verb{source = {script}} or when the source field specifies multiple URLs.
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
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' process.bib("DATA.bib")
#' process.bib("SOFTWARE.bib")
#' }
#'
#' @importFrom bibtex read.bib
#'
#' @export

process.bib <- function(bibfile, clean=TRUE, quiet=FALSE)
{
  if(!quiet)
    message("Processing ", bibfile)
  type <- if(bibfile == "DATA.bib") "data"
          else if(bibfile == "SOFTWARE.bib") "software"
          else stop("bibfile must be 'DATA.bib' or 'SOFTWARE.bib'")

  if(clean && type=="data")
  {
    clean("data")
    if(!quiet)
      message("  cleaned 'bootstrap/data'")
  }
  if(clean && type=="software")
  {
    clean.software("software", quiet=quiet)
    clean.library("library", quiet=quiet)
  }

  entries <- if(file.exists(bibfile)) read.bib(bibfile) else list()
  dups <- anyDuplicated(names(entries))
  if(dups)
    stop("Duplicated key: '", names(entries)[dups], "'")

  for(bib in entries)
  {
    key <- attr(bib, "key")
    if(!quiet)
      message("* ", key)

    ## If source contains multiple files then split into vector
    bib$source <- trimws(unlist(strsplit(bib$source, "\\n")))
    bib$source <- sub(",$", "", bib$source)     # remove trailing comma
    bib$source <- bib$source[bib$source != ""]  # remove empty strings

    ## icesTAF:::access.vocab is a string vector of allowed 'access' values
    access <- bib$access
    if(!is.character(access) || !all(as.character(access) %in% access.vocab))
      stop("'access' values must be \"",
           paste(access.vocab, collapse="\", \""), "\"")

    ## Add prefix
    bib$source <- paste0(bib$prefix, bib$source)

    ## Prepare dir, where bib$dir starts as: TRUE, FALSE, string, or NULL
    bib$dir <- as.logical(bib$dir)  # is now TRUE, FALSE, NA, or logical(0)
    if(identical(bib$dir, NA))
      stop("parsing entry '", key, "' - dir should be TRUE or unspecified")
    dir <- if(identical(bib$dir, TRUE) ||
              length(bib$source) > 1 ||
              bib$source[1] == "script")
             file.path(type, key) else type
    mkdir(dir)  # target directory

    process.inner(bib, dir, quiet)
  }

  invisible(TRUE)
}
