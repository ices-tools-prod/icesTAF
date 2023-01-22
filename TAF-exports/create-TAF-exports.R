# see:
# https://github.com/r-lib/devtools/blob/main/R/remotes.R


# get TAF exports
ns <- loadNamespace("TAF")
TAF_functions <- unlist(eapply(ns, inherits, "function"))
TAF_functions <- names(TAF_functions)[which(TAF_functions)]
TAF_functions <- setdiff(TAF_functions, "taf.skeleton")

import_block <- function(fun_name, first = FALSE) {

  nametag <-
    if (first) {
      paste(
        "#' @name taf-reexports",
        "#' @keywords internal",
        sep = "\n"
      )
    } else {
      "#' @rdname taf-reexports"
    }

  paste(
    paste0("#' @importFrom TAF ", fun_name),
    nametag,
    "#' @export",
    paste0(fun_name, " <- TAF::", fun_name, "\n"),
    sep = "\n"
  )
}

taf.skeleton.txt <-
  "#' @importFrom TAF taf.skeleton
#' @rdname taf-reexports
#' @export
taf.skeleton <- function(path = \".\", force = FALSE, pkgs = \"icesTAF\") {
  TAF::taf.skeleton(path = path, force = force, pkgs = pkgs)
}
"


TAF_R <-
  paste(
    "#' Functions re-exported from the TAF package",
    "#'",
    "",
    "#' These functions are re-exported from the TAF package.",
    "#'",
    "#' Follow the links below to see the documentation.",
    paste0("#' ", paste("[TAF::", TAF_functions, "]", collapse = ", ", sep = "")),
    "#'",
    import_block(TAF_functions[1], first = TRUE),
    paste0(sapply(TAF_functions[-1], import_block), collapse = "\n"),
    taf.skeleton.txt,
    sep = "\n"
  )

cat(
  TAF_R,
  file = "R/TAF.R"
)
