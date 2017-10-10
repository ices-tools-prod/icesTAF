#' Create a Skeleton for a New TAF Analysis
#'
#' \code{taf.skeleton()} is motivated by \code{package.skeleton}. It automates
#' some of the setup for a new TAF analysis. It creates directories, saves functions,
#' data, and R code files to appropriate places, and creates a ‘Read-and-delete-me’
#' file describing further steps to create a functioning TAF analysis.
#'
#'
#' @param name character string: the package name and directory name for your package.
#' @param list character vector naming the R objects to put in the package. Usually, at most one of list, environment, or code_files will be supplied. See ‘Details’.
#' @param environment	an environment where objects are looked for. See ‘Details’.
#' @param path path to put the package directory in.
#' @param force	If FALSE will not overwrite an existing directory.
#' @param code_files a character vector with the paths to R code files to build the package around. See ‘Details’.
#' @param encoding optionally a character string with an encoding for an optional Encoding: line in ‘DESCRIPTION’ when non-ASCII characters will be used; typically one of "latin1", "latin2", or "UTF-8"; see the WRE manual.
#'
#' @export

taf.skeleton <- function (name = "aTAFanalysis", list = character(), environment = .GlobalEnv,
    path = ".", force = FALSE, code_files = character(), encoding = "UTF-8-DOM")
{

}

