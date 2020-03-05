#########################################################################
#' Generate scFlowExample dataset for scFlow and nf-core-scflow
#'
#' @param output_dir Path for the output dir. Default is current directory
#'
#' @importFrom DropletUtils write10xCounts
#' @import One2One
#'
#' @author Nurun Fancy <n.fancy@imperial.ac.uk>
#'
#' @export

write_data <- function(output_dir = ".") {

  # load data
  data("indvExp", package = "scFlowExamples")

  # Create a folder to store the 10xGenomics matrix format data
  output_path <- file.path(output_dir, "tmp_Zeisel2015_scflow")
  dir.create(output_path)

  for (i in 1:length(indvExp)) {
    x <- indvExp[[i]]$exp

    # Convert gene symbols from mouse to human
    # Limit genes to Mouse:Human orthologs
    # Convert human gene symbols to Ensembl gene IDs

    x <- mouse_symbol_to_human_ensembl(x)

    # Write the data

    output_file <- sprintf("%s/individual_%s", output_path, i)
    DropletUtils::write10xCounts(output_file, x,
      barcodes = colnames(x),
      gene.id = rownames(x),
      gene.symbol = rownames(x),
      gene.type = "Gene Expression",
      overwrite = TRUE,
      type = "auto",
      genome = "unknown",
      version = "3"
    )
  }
}

#' Write Manifest file to be run by scFlow and nf-core-scflow
#'
#' @param indvExp indvExp loaded by the first function write_data.
#' @param output_dir Path for the output dir. Default is current directory.
#'
#' @importFrom ids proquint
#'
#' @author Nurun Fancy <n.fancy@imperial.ac.uk>
#'
#' @export

write_scflow_manifest <- function(indvExp = indvExp, output_dir = ".") {
  output_path <- file.path(output_dir, "tmp_Zeisel2015_scflow")
  y <- ids::proquint(n = length(indvExp),
                     n_words = 1L,
                     use_cache = TRUE,
                     use_openssl = FALSE)
  z <- data.frame(key = y, filepath = sprintf(
    "%s/%s", output_path, list.files(output_path, pattern = "individual")),
    stringsAsFactors = FALSE)
  write.table(z, file = sprintf(
    "%s/Manifest.txt", output_path), row.names = FALSE, col.names = TRUE,
    quote = FALSE, sep = "\t")
}

#' Write SampleSheet file to be run by scFlow and nf-core-scflow
#'
#' The scFlowExample dataset, Manifest.txt and SampleSheet.tsv files can
#' be prepared using three simple functions.
#'
#' @param indvExp indvExp loaded by the first function write_data.
#' @param output_dir Path for the output dir. Default is current directory.
#'
#' @author Nurun Fancy <n.fancy@imperial.ac.uk>
#'
#' @export

write_scflow_samplesheet <- function(indvExp = indvExp, output_dir = ".") {
  output_path <- file.path(output_dir, "tmp_Zeisel2015_scflow")
  manifest <- read.delim(file = file.path(output_path, "Manifest.txt"),
                         header = TRUE)
  dx <- unlist(lapply(indvExp, FUN = function(x) {
    return(x$dx)
  }))
  sex <- sample(c("M", "F"), length(dx), replace = T)
  age <- sample(seq(3, 18, 3), length(dx), replace = TRUE)
  sample_sheet <- cbind(manifest = as.character(manifest$key),
                        individual = rownames(manifest),
                        diagnosis = dx,
                        sex = sex,
                        age = age)
  write.table(sample_sheet,
              file = sprintf("%s/SampleSheet.tsv", output_path),
              row.names = FALSE,
              col.names = TRUE,
              quote = FALSE,
              sep = "\t")
}
