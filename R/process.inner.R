## process.bib helper function

#' @importFrom remotes parse_repo_spec
#' @importFrom tools file_path_as_absolute

process.inner <- function(bib, dir, quiet)
{
  key <- attr(bib, "key")
  if(!quiet)
    message("* ", key)

  ## Case 1: R package on GitHub
  if(grepl("@", bib$source[1]))
  {
    mkdir("software")
    spec <- parse_repo_spec(bib$source)
    sha <- get_remote_sha(spec$username, spec$repo, spec$ref)  # branch -> sha
    spec$ref <- substring(sha, 1, 7)
    url <- paste0("https://api.github.com/repos/",
                  spec$username, "/", spec$repo, "/tarball/", spec$ref)
    targz <- paste0(spec$repo, "_", spec$ref, ".tar.gz")
    if(!file.exists(file.path("software", targz)))
      suppressWarnings(download(url, destfile=file.path("software", targz)))
  }

  ## Case 2: File to download
  else if(grepl("^http", bib$source[1]))
  {
    sapply(bib$source, download, dir=dir)
  }

  ## Case 3: R script in bootstrap directory
  else if(bib$source[1] == "script")
  {
    script <- file_path_as_absolute(paste0(key, ".R"))
    owd <- setwd(dir); on.exit(setwd(owd))
    source(script)
  }

  ## Case 4: File to copy
  else
  {
    ## Shorthand notation: source = {file} means key is a filename
    if(bib$source[1] == "file")
      bib$source[1] <- file.path("initial", dir, key)
    sapply(bib$source, cp, to=dir)
  }
}
