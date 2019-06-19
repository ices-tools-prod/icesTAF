#' @importFrom remotes install_github parse_repo_spec

taf.install <- function(repo, wd=".")
{
  owd <- setwd(wd); on.exit(setwd(owd))
  mkdir(c("library", "software"))
  spec <- parse_repo_spec(repo)
  url <- paste0("https://api.github.com/repos/",
                spec$username, "/", spec$repo, "/tarball/", spec$ref)
  targz <- paste0(spec$repo, "_", spec$ref, ".tar.gz")
  if(!file.exists(file.path("software", targz)))
    suppressWarnings(download(url, destfile=file.path("software", targz)))
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
    install_github(repo, lib="library", dependencies=FALSE,
                   upgrade=FALSE, force=TRUE)
  }
}

## Check whether requested package is already installed in the TAF library

#' @importFrom utils installed.packages packageDescription

already.in.taf.library <- function(spec)
{
  pkg <- basename(file.path(spec$repo, spec$subdir))
  sha.bib <- get_remote_sha(spec$username, spec$repo, spec$ref)
  sha.inst <- if(pkg %in% row.names(installed.packages("library")))
                packageDescription(pkg, "library")$RemoteSha else NULL
  sha.inst <- substring(sha.inst, 1, nchar(sha.bib))
  out <- identical(sha.bib, sha.inst)
  out
}


# get_remote_sha("ices-tools-prod", "icesTAF", "master")
# get_remote_sha("ices-tools-prod", "icesTAF", "3.1-1")
# get_remote_sha("ices-tools-prod", "icesTAF", "577347aa6ee63add3720c3b27e582ee37fc8f92d")

get_remote_sha <- function(username, repo, ref, use_curl = FALSE) {
  # form api url to get latest commit
  url <-
    paste(
      "https://api.github.com/repos", username, repo,
      "commits", utils::URLencode(ref, reserved = TRUE),
      sep = "/")

  if (use_curl) {
    # set up curl
    h <- curl::new_handle()
    headers <- c(Accept = "application/vnd.github.v3.sha")
    curl::handle_setheaders(h, .list = headers)
    # preform fetch
    res <- curl::curl_fetch_memory(url, handle = h)
    # return content
    rawToChar(res$content)
  } else {
    tmp <- tempfile()
    on.exit(unlink(tmp), add = TRUE)
    # download json contents to temporary file
    download.file(url, tmp, quiet = TRUE)
    # parse json - jsonlite comes with remotes anyway
    res <- jsonlite::read_json(tmp)
    # return sha
    res$sha
  }
}
