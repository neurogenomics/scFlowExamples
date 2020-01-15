You must have hdf5 setup on your system to run this. If using linux, run
“sudo apt-get install libhdf5-dev”.

Install packages
----------------

These should all be setup within Renv but this is what’s needed:


    #devtools::install_github("combiz/scflow",auth="TOKEN",dependencies = TRUE)

Setup the dataset
-----------------

    # create a temporary directory
    td = tempdir()
    # create the placeholder file
    tf = tempfile(tmpdir=td, fileext=".loom")
    # download into the placeholder file
    download.file("https://storage.googleapis.com/linnarsson-lab-loom/l5_all.loom", tf) # tf="~/l5_all.loom"
    unzip(tf)

    allExp = prep_zeisel2018(path=tf)
    keptExp = merge_zeisel_celltypes(allExp,useCells=c("TEGLU1","TEGLU2","MGL1","MOL1"))
    indvExp = split_celltypes_byIndv(keptExp,joinCells=c("TEGLU1","TEGLU2"),nCases=3,jointName="Pyramidal")

    # Save data set so that it can be used easily
    usethis::use_data(indvExp)

Save the data to file
---------------------

It’s not really neccesary to run the above code, you could just run
`data(indvExp)` and continue from here.

``` r
load("data/indvExp.rda")
# Create a folder to store the 10xGenomics matrix format data
output_path <- "~/tmp_ZeiselSCFLOW"
dir.create(output_path)
```

    ## Warning in dir.create(output_path): '/home/nskene/tmp_ZeiselSCFLOW' already
    ## exists

``` r
for(i in 1:length(indvExp)){
  x = indvExp[[i]]$exp
  
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
  
  # Write the data
  
  output_file <- sprintf("%s/individual_%s",output_path,i)
  DropletUtils::write10xCounts(output_file, x, barcodes=colnames(x), gene.id=rownames(x),
    gene.symbol=rownames(x), gene.type="Gene Expression", overwrite=TRUE, 
    type="auto", genome="unknown", version="3")
}
```

Create the manifesto file for scFlow
------------------------------------

``` r
y <- ids::proquint(n = length(indvExp), n_words = 1L, use_cache = TRUE, use_openssl = FALSE)
z <- data.frame(key = y, filepath = sprintf("%s/%s",output_path,list.files(output_path,pattern="individual")),stringsAsFactors = FALSE)
write.table(z, file = sprintf("%s/Manifest.txt",output_path), row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t")
```

Create the sample sheet for scFlow
----------------------------------

``` r
dx <- unlist(lapply(indvExp,FUN=function(x){return(x$dx)}))
sex <- sample(c("M","F"),length(dx),replace=T)
age <- sample(1:100,length(dx))
sample_sheet <- cbind(manifest=z[,1],individual=rownames(z),diagnosis=dx,sex=sex)
write.table(sample_sheet,file=sprintf("%s/SampleSheet.tsv",output_path), row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t")
#individual     group   diagnosis   coverage    sex     age     PMI     duration    capdate     prepdate    seqdate     MLS     RIN     manifest
```
