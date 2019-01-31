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
#' identifying a specific version of an R package. A fixed reference such as a
#' tag, release, or SHA-1 hash is recommended. Branch names, such as
#' \verb{master}, are pointers that are subject to change, and are therefore not
#' reliable as long-term references.
#' \item URL starting with \verb{http} or \verb{https}, identifying a file to
#' download.
#' \item Relative path starting with \file{initial}, identifying the location of
#' a file or folder provided by the user.
#' \item Special value \code{file}, indicating that the metadata key points to a
#' file location.
#' }
#'
#' Consider, for example, the following metadata entry from a \verb{DATA.bib}
#' file:
#' \preformatted{@Misc{catch.csv,
#'   originator = {WGEF},
#'   year       = {2015},
#'   title      = {Annual catch of rjm-347d},
#'   period     = {2012-2014},
#'   source     = {file},
#' }}
#' Here, a data file is described using the \verb{@Misc} entry type and the
#' string following the entry type is called a \dfn{key}. The next fields state
#' that this file was supplied by the Elasmobranch working group in 2015 and it
#' contains the annual catch of North Sea spotted ray from 2012 to 2014. The
#' special value \verb{source = {file}} means that the key, in this case
#' \verb{catch.csv}, is the name of the file located inside
#' \verb{bootstrap/initial/data}. This \verb{file} shorthand notation is
#' equivalent to specifying the relative path:
#' \verb{source = {initial/data/catch.csv}}.
#'
#' Another example metadata entry is from a \verb{SOFTWARE.bib} file:
#' \preformatted{@Manual{icesAdvice,
#'   author  = {Arni Magnusson and Colin Millar and Anne Cooper},
#'   year    = {2018},
#'   title   = {icesAdvice: Functions Related to ICES Advice},
#'   version = {2.0-0, released 2018-12-07},
#'   source  = {cran/icesAdvice@2.0-0},
#' }}
#' This entry describes a specific version of an R package that is required for
#' the TAF analysis. It is similar, but not identical, to the output from the R
#' command \verb{citation("icesAdvice")}. The version field specifies the
#' version number and release date, with a corresponding GitHub reference. When
#' an R package is not an official release but a development version, the
#' version and source may look like this,
#' \preformatted{  version = {2.6.6, committed 2018-02-21},
#'   source  = {flr/FLCore@d0333c1},}
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
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' process.bib("DATA.bib")
#' process.bib("SOFTWARE.bib")
#' }
#'
#' @importFrom remotes install_github parse_repo_spec
#' @importFrom bibtex read.bib
#'
#' @export

process.bib <- function(bibfile)
{
  dir <- if(bibfile == "DATA.bib") "data"
         else if(bibfile == "SOFTWARE.bib") "software"
         else stop("bibfile must be 'DATA.bib' or 'SOFTWARE.bib'")
  mkdir(dir)

  entries <- if(file.exists(bibfile)) read.bib(bibfile) else list()

  for(bib in entries)
  {
    ## R package on GitHub
    if(grepl("@", bib$source))
    {
      spec <- parse_repo_spec(bib$source)
      url <- paste0("https://api.github.com/repos/",
                    spec$username, "/", spec$repo, "/tarball/", spec$ref)
      targz <- paste0(spec$repo, "_", spec$ref, ".tar.gz")
      suppressWarnings(download(url, destfile=file.path(dir, targz)))
      install_github(bib$source, upgrade=FALSE, force=TRUE)
    }
    ## File to download
    else if(grepl("^http", bib$source))
    {
      download(bib$source, dir=dir)
    }
    ## File to copy
    else
    {
      ## Shorthand notation: source = {file} means key is a filename
      if(bib$source == "file")
        bib$source <- file.path("initial", dir, attr(bib,"key"))
      cp(bib$source, dir)
    }
  }
}
