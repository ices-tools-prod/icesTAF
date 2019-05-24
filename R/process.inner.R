## process.bib helper function

#' @importFrom remotes install_github parse_repo_spec
#' @importFrom tools file_path_as_absolute

process.inner <- function(bib, dir, quiet)
{
  key <- attr(bib, "key")
  if(!quiet)
    message("* ", key)

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

  ## Case 3: R script in bootstrap directory
  else if(bib$source[1] == "script")
  {
    script <- file_path_as_absolute(paste0(key, ".R"))
    owd <- setwd(dir)
    source(script)
    setwd(owd)
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
