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

The current dataset uses `TEINH15`, `TEINH19`, `MGL1`, `MOL1` cells. For
a list of available cell types please visit [this
link](http://mousebrain.org/celltypes/). Use the following codes only if
you want to use different cell types.

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

# Save dataset so that it can be used easily
usethis::use_data(indvExp, overwrite = TRUE)
```

Save the data to file
---------------------

You could just run the following codes and continue from here. The
following codes will generate scFlowExample dataset in 10x genomics
Cellranger output format, a `Manifest.txt` file containing data path for
individual samples and a `SampleSheet.tsv` containing sample metadata.

``` r
write_data()
write_scflow_manifest(indvExp)
write_scflow_samplesheet(indvExp)
```
