#########################################################################
#' Convert gene symbols from mouse to human and then to human ensembl IDs
#'
#' @param x Object of class dgCMatrix 
#'
#' @importFrom One2One ortholog_data_Mouse_Human
#' @importFrom biomaRt useMart
#' @importFrom biomaRt getBM
#'
#' @export


mouseSymbol_to_humanEnsembl <- function(x,
                            ...) {

  # Convert gene symbols from mouse to human
  # Limit genes to Mouse:Human orthologs
  
  mouse2human <- One2One::ortholog_data_Mouse_Human$orthologs_one2one 
  rownames(mouse2human) <- mouse2human$mouse.symbol
  
  x <- x[rownames(x) %in% mouse2human$mouse.symbol,]
  mouse2human2 <- mouse2human[rownames(x),]
  rownames(x) <- mouse2human2$human.symbol
  
  # Convert human gene symbols to Ensembl gene IDs
  
  ensembl <- biomaRt::useMart("ensembl",dataset="hsapiens_gene_ensembl")
  
  hgnc2ensg <- biomaRt::getBM(attributes=c('hgnc_symbol', 'ensembl_gene_id'), 
        filters = 'hgnc_symbol', 
        values = rownames(x), 
        mart = ensembl)
  
  hgnc2ensg <- as.data.frame(hgnc2ensg, row.names = hgnc2ensg$hgnc_symbol)
  
  x <- x[rownames(x) %in% hgnc2ensg$hgnc_symbol,]  
  hgnc2ensg2 <- hgnc2ensg[rownames(x),]
  rownames(x) <- hgnc2ensg2$ensembl_gene_id

  return(x)

}