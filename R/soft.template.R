soft.template <- function(package, version=NULL, source=NULL, file="")
{
  ## 1  Bibliographic info: author, year, title, details
  bib <- as.list(toBibtex(citation(package)[1]))
  key <- sub(",$", paste0(package,","), bib[[1]])  # add package name
  bibtype <- tolower(sub("@(.*)\\{.*", "\\1", key))
  details <- switch(bibtype,
                    article=c(bib$journal, bib$volume, bib$number,
                              bib$pages, bib$doi),
                    book=c(bib$edition, bib$address, bib$publisher, bib$doi),
                    techreport=c(bib$institution, bib$edition,
                                 bib$number, bib$note, bib$doi),
                    bib$doi)

  ## 2  Package info: version, source
  pkg <- packageDescription(package)
  repotype <- if(isTRUE(pkg$Repository == "CRAN")) "CRAN"
              else if(isTRUE(pkg$RemoteType == "github")) "GitHub"
              else if(!is.null(pkg$Repository)) pkg$Repository
              else NA_character_
  if(is.null(version))
  {
    released <- if(isTRUE(repotype == "CRAN"))
                  paste(", released", substring(pkg$"Date/Publication",1,10))
    version <- paste0(pkg$Version, released)
  }
  version <- paste0("  version = {", version, "},")
  if(is.null(source))
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
  output <- c(key, fields, "}")
  class(output) <- "Bibtex"

  ## 4  Export
  ## Avoid write() when file="", to ensure quiet assignment x <- data.template()
  if(file == "")
  {
    output
  }
  else
  {
    write(output, file=file)
    invisible(output)
  }
}
