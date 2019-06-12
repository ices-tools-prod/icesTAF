## ds = draft.software helper function

#' @importFrom utils citation packageDescription toBibtex

ds.package <- function(package, author, year, title, version, source)
{
  ## 1  Bibliographic info: author, year, title, details
  cit <- citation(package, lib.loc=c("bootstrap/library",.libPaths()))[1]
  bib <- as.list(toBibtex(cit))
  key <- sub(",$", paste0(package,","), bib[[1]])  # add package name
  ## Treat null and NA (from mapply) the same, must test null first
  author <- if(is.null(author) || is.na(author)) bib$author
            else paste0("  author = {", author, "},")
  year <- if(is.null(year) || is.na(year)) bib$year
          else paste0("  year = {", year, "},")
  title <- if(is.null(title) || is.na(title)) bib$title
           else paste0("  title = {", title, "},")
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
  pkg <- packageDescription(package, lib.loc=c("bootstrap/library",.libPaths()))
  repotype <- if(isTRUE(pkg$Repository == "CRAN")) "CRAN"
              else if(isTRUE(pkg$RemoteType == "github")) "GitHub"
              else if(!is.null(pkg$Repository)) pkg$Repository
              else NA_character_
  if(is.null(version) || is.na(version))
  {
    released <- if(isTRUE(repotype == "CRAN"))
                  paste(", released", substring(pkg$"Date/Publication",1,10))
    version <- paste0(pkg$Version, released)
  }
  version <- paste0("  version = {", version, "},")
  if(is.null(source) || is.na(source))
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
  fields <- c(author, year, title, details, version, source)
  fields <- strsplit(fields, "=")  # align at equals sign
  fields <- paste0(format(sapply(fields,"[",1)), "=", sapply(fields,"[",2))
  out <- c(key, fields, "}")
  class(out) <- "Bibtex"

  out
}
