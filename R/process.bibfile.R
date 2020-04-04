#' @rdname icesTAF-internal
#'
#' @importFrom bibtex read.bib
#'
#' @export

## Process *.bib file

process.bibfile <- function(bibfile, clean=TRUE, quiet=FALSE)
{
  if(!quiet)
    message("Processing ", bibfile)
  type <- if(bibfile == "DATA.bib") "data"
          else if(bibfile == "SOFTWARE.bib") "software"
          else stop("bibfile must be 'DATA.bib' or 'SOFTWARE.bib'")

  if(clean && type=="data" && dir.exists("data"))
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

    ## Check if access matches allowed values
    access <- bib$access
    if(!is.null(access))
    {
      ## icesTAF:::access.vocab is a string vector of allowed 'access' values
      if(!is.character(access) || !(access %in% access.vocab))
        stop("'access' values must be \"",
             paste(access.vocab, collapse="\", \""), "\"")
    }

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

    process.entry(bib, dir, quiet)
  }

  invisible(TRUE)
}
