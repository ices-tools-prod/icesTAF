
# get TAF exports
ns <- loadNamespace("TAF")
TAF_functions <- unlist(eapply(ns, inherits, "function"))
TAF_functions <- names(TAF_functions)[which(TAF_functions)]

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
    sep = "\n"
  )

cat(
  TAF_R,
  file = "R/TAF.R"
)
