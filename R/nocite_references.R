#' Generate Nocite Block
#'
#' Include a metadata block of citation keys for including citations in
#' references file without in-text citations.
#'
#' When passed a list of citation keys, adds the @@ to each, then builds the
#' nocite metadata field, returning via "as-is" output. Run this function either
#' inline or within a code chunk (with `echo = FALSE`) to include this
#' metadata block within an RMarkdown document. The code chunk need not
#' explicitly state `results = 'asis'`.
#'
#' Call `nocite_references` with either `style = 'pandoc'` or
#' `style = 'latex'` depending on whether you are processing citations with
#' pandoc-citeproc or a LaTeX citation processor such as biblatex or natbib.
#'
#' This function is intended to cite R packages with citation keys passed from
#' [get_citations()] or `cite_packages(output = "citekeys")`,
#' but can accept an arbitrary vector of citation keys (without @@)
#' found in a BibTeX file referenced in the YAML header.
#'
#' @param citekeys Vector of citation keys in reference to a relevant BibTeX
#'   file.
#' @param citation_processor Mechanism for citation processing when knitting to
#'   PDF or otherwise using LaTeX. Selects the appropriate formatting of the
#'   nocite command. Either "pandoc" or "latex". If processing with
#'   pandoc-citeproc, use the nocite metadata block. If processing via a LaTeX
#'   processor such as natbib or biblatex, put in the LaTeX \code{\\nocite\{\}}
#'   command directly. If knitting to any non-LaTeX format, this parameter is
#'   ignored, and a pandoc-citeproc style block is used.
#'
#' @return "As is" text of metadata block, with comma-separated list of citation
#'   keys.
#' @export
#' @author Connor P. Jackson
#'
#' @examplesIf interactive()
#' # include in YAML header:
#' # bibliography: grateful-refs.bib
#'
#' # Get citation keys for the current RMarkdown document
#' # (run after all packages have been loaded).
#' citekeys <- cite_packages(output = "citekeys", out.dir = tempdir())
#'
#' # Include in RMarkdown body for use with pandoc-citeproc:
#' # `r nocite_references(citekeys, citation_processor = 'pandoc')`

nocite_references <- function(citekeys, citation_processor = c('pandoc', 'latex')) {
  # The citation processor only matters if LaTeX might be processing the
  # citations. Otherwise, just use pandoc-citeproc style nocite block
  if (knitr::is_latex_output() == FALSE) citation_processor <- 'pandoc'

  if (tolower(citation_processor) == 'pandoc') {
    nocites <- paste0("@", citekeys, collapse = ", ")
    nocite_command <- paste("---\nnocite: |\n\t", nocites, "\n...")
  } else if (tolower(citation_processor) == 'latex') {
    nocites <- paste0(citekeys, collapse = ", ")
    nocite_command <- paste0("\\nocite{", nocites, "}")
  } else stop("Invalid citation processing style.")
  knitr::asis_output(nocite_command)
}
