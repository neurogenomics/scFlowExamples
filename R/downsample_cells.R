#########################################################################
#' Downsample to get fewer cells from the specified cell type
#'
#' @param keptExp A dgCMatrix object where genes as rows and cells as
#' columns. Output from scFlowExamples::merge_zeisel_celltypes() function.
#' @param prop_cell A vector containing cell proportion to downsample.
#' Should be of same length as the cell types in the dgCMatrix. Value
#' ranges between 0-1.
#' @param n_top_genes Number of top variable genes to downsample. If NULL
#' all genes are returned.
#'
#' @author Nurun Fancy <n.fancy@imperial.ac.uk>
#' @importFrom matrixStats rowVars
#' @export
downsample_cells <- function(keptExp,
                             prop_cell = NULL,
                             n_top_genes = NULL){

  all_celltype <- unique(colnames(keptExp))
  exp_list <- list()
  for(i in all_celltype){
    idx <- which(colnames(keptExp) %in% i)
    exp_list[[i]] <- keptExp[, idx]
  }

  exp_list_sampled <- Map(ds_cell, exp_list, prop_cell)

  keptExp = exp_list_sampled[[1]]
  for(i in 2:length(exp_list_sampled)){
    tmp = exp_list_sampled[[i]]
    keptExp = cbind(keptExp,tmp)
  }

  if (is.null(n_top_genes)) {
    cat(paste("All genes are returned!\n"))
  } else if (!is.null(n_top_genes)) {
    cat(paste("Top", n_top_genes, "variable genes are returned!\n"))
    top_var_genes <- head(order(matrixStats::rowVars(as.matrix(keptExp), na.rm = TRUE), decreasing=TRUE), n_top_genes)
    keptExp <- keptExp[top_var_genes, ]
  }

  return(keptExp)
}


#' Downsampling function for a single cell type
#'
#' @param exp A dgCMatrix object where genes as rows and cells as
#' columns.
#' @param prop_cell Proportion of original cell number to downsample.
#' Value ranges between 0-1. Providing expected proportion will override
#' n_cell.
#'
#' @author Nurun Fancy <n.fancy@imperial.ac.uk>
#'
#' @export
ds_cell <- function(exp,
                    prop_cell = prop_cell){

    cell_type <- unique(colnames(exp))
    total_cells <- ncol(exp)
    n_cell <- round(total_cells * prop_cell)
    cat(paste("Returning", n_cell, "cells from a total of", total_cells, cell_type, "cells!\n"))

  idx <- ncol(exp)
  idx_sampled <- sample(x = idx, size = n_cell, replace = FALSE)
  exp <- exp[, idx_sampled]
  return(exp)
}

