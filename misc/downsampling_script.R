library(scFlowExamples)
td <- tempdir()
tf <- tempfile(tmpdir = td, fileext = ".loom")
download.file("https://storage.googleapis.com/linnarsson-lab-loom/l5_all.loom", tf) # tf="~/l5_all.loom"
unzip(tf)

allExp <- prep_zeisel2018(path = tf)
keptExp <- merge_zeisel_celltypes(allExp, useCells = c("TEINH15", "TEINH19", "MGL1", "MOL1"))
keptExp_ds <- downsample_cells(keptExp = keptExp,
                               prop_cell = c(0.5,0.5,0.05,0.02)
                               )
keptExp_ds_4K <- downsample_cells(keptExp = keptExp,
                                    prop_cell = c(0.5,0.5,0.05,0.02),
                                    n_top_genes = 4000)


indvExp <- split_celltypes_byIndv(keptExp, joinCells = c("TEINH15", "TEINH19"), nCases = 3, jointName = "TEINH")
indvExp_ds <- split_celltypes_byIndv(keptExp_ds, joinCells = c("TEINH15", "TEINH19"), nCases = 3, jointName = "TEINH")
indvExp_ds_4K <- split_celltypes_byIndv(keptExp_ds_4K, joinCells = c("TEINH15", "TEINH19"), nCases = 3, jointName = "TEINH")

usethis::use_data(indvExp, overwrite = TRUE)
usethis::use_data(indvExp_ds, overwrite = TRUE)
usethis::use_data(indvExp_ds_4K, overwrite = TRUE)


##########
#To use the full size dataset
data("indvExp", package = "scFlowExamples")

#To use a downsampled dataset
data("indvExp_downsampled", package = "scFlowExamples")

#To use a downsampled dataset
data("indvExp_downsampled_4000genes", package = "scFlowExamples")


#To write out the data in 10X genomics format
write_data(indvExp = indvExp_downsampled_4000genes, output_dir = "~/scflow_ds_genes/")
write_scflow_manifest(indvExp = indvExp_downsampled_4000genes, output_dir = "~/scflow_ds_genes")
write_scflow_samplesheet(indvExp = indvExp_downsampled_4000genes, output_dir = "~/scflow_ds_genes")
