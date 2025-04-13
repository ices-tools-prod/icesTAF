## taken from jeroen/jsonlite:
## https://github.com/jeroen/jsonlite/blob/a10888a53dbbebaa46e4e6733f4ff1600a3abff2/R/loadpkg.R#L1-L6

loadpkg <- function(pkg) {
  tryCatch(getNamespace(pkg), error = function(e) {
    stop(
      "Required package ", pkg, " not found. Please run: install.packages('", pkg, "')",
      call. = FALSE
    )
  })
}
