Prerequisite
------------

To preprocess scFlowExamples dataset, the following packages should be
installed.

``` r
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}
BiocManager::install("DropletUtils")

install.packages("ids")

devtools::install_github("NathanSkene/One2One")
```

Install the dataset repository
------------------------------

``` r
devtools::install_github("neurogenomics/scFlowExample")
```

Setup the dataset
-----------------

``` r
# create a temporary directory
td <- tempdir()

# create the placeholder file
tf <- tempfile(tmpdir = td, fileext = ".loom")

# download into the placeholder file
download.file("https://storage.googleapis.com/linnarsson-lab-loom/l5_all.loom", tf) # tf="~/l5_all.loom"
unzip(tf)

allExp <- prep_zeisel2018(path = tf)
keptExp <- merge_zeisel_celltypes(allExp, useCells = c("TEINH15", "TEINH19", "MGL1", "MOL1"))
indvExp <- split_celltypes_byIndv(keptExp, joinCells = c("TEINH15", "TEINH19"), nCases = 3, jointName = "Teinh")

# Save data set so that it can be used easily
usethis::use_data(indvExp, overwrite = TRUE)
```

Save the data to file
---------------------

It’s not really neccesary to run the above code, you could just run the
following codes and continue from here.

``` r
indvExp <- scFlowExamples::indvExp

# Create a folder to store the 10xGenomics matrix format data
output_path <- "~/tmp_ZeiselSCFLOW"
dir.create(output_path)

# Write the data
for (i in 1:length(indvExp)) {
  x <- indvExp[[i]]$exp
  x <- mouse_symbol_to_human_ensembl(x)

  output_file <- sprintf("%s/individual_%s", output_path, i)
  DropletUtils::write10xCounts(output_file, x,
    barcodes = colnames(x), gene.id = rownames(x),
    gene.symbol = rownames(x), gene.type = "Gene Expression", overwrite = TRUE,
    type = "auto", genome = "unknown", version = "3"
  )
}
```

Create the manifesto file for *scflow*
--------------------------------------

``` r
y <- ids::proquint(n = length(indvExp), n_words = 1L, use_cache = TRUE, use_openssl = FALSE)
z <- data.frame(key = y, filepath = sprintf("%s/%s", output_path, list.files(output_path, pattern = "individual")), stringsAsFactors = FALSE)
write.table(z, file = sprintf("%s/Manifest.txt", output_path), row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t")
```

Create the sample sheet for *scflow*
------------------------------------

``` r
dx <- unlist(lapply(indvExp, FUN = function(x) {
  return(x$dx)
}))
sex <- sample(c("M", "F"), length(dx), replace = T)
age <- sample(1:100, length(dx))
sample_sheet <- cbind(manifest = z[, 1], individual = rownames(z), diagnosis = dx, sex = sex)
write.table(sample_sheet, file = sprintf("%s/SampleSheet.tsv", output_path), row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t")
```
