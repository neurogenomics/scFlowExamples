#########################################################################
#' Convert gene symbols from mouse to human and then to human ensembl IDs
#'
#' @param dt Object of class dgCMatrix
#'
#' @importFrom One2One ortholog_data_Mouse_Human
#'
#' @export


mouse_symbol_to_human_ensembl <- function(dt) {

  # Convert gene symbols from mouse to human
  # Limit genes to Mouse:Human orthologs

  mouse2human <- One2One::ortholog_data_Mouse_Human$orthologs_one2one
  rownames(mouse2human) <- mouse2human$mouse.symbol

  dt <- dt[rownames(dt) %in% mouse2human$mouse.symbol, ]
  mouse2human2 <- mouse2human[rownames(dt), ]
  rownames(dt) <- mouse2human2$human.symbol

  # Convert human gene symbols to Ensembl gene IDs

  hgnc2ensg <- .human_geneid_conversion(
    keys = rownames(dt),
    keytype = "Gene.name",
    columns = c("Gene.name", "Gene.stable.ID")
  )
  hgnc2ensg <- na.omit(hgnc2ensg)
  rownames(hgnc2ensg) <- NULL
  dt <- dt[match(hgnc2ensg$Gene.name, rownames(dt)), ]
  rownames(dt) <- hgnc2ensg$Gene.stable.ID

  return(dt)
}

#' @keywords internal

.human_geneid_conversion <- function(keys, keytype, columns) {
  ensembl_mappings <- read.delim(file = paste(
    system.file("extdata", package = "scFlowExamples"), "/",
    "Human_ensg_hgnc_biomart.tsv",
    sep = ""
  ), stringsAsFactors = FALSE)

  keys <- as.character(keys)

  ids <- match(keys, ensembl_mappings[, keytype])

  res <- ensembl_mappings[ids, columns]

  return(res)
}
