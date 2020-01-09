#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# Install packages
install.packages("yaml")
library(yaml)

cran_url <- 'https://cran.ma.imperial.ac.uk/'

# Load Package Vectors
yaml_packages <- read_yaml(file = "tmp/rpackages.yml")

if (args[1] == "CRAN") {
    # Install Packages from CRAN
    install.packages(pkgs = yaml_packages$packages_from_CRAN, dependencies = TRUE, repos = cran_url)
} else if (args[1] == "Bioconductor") {
    # Install Packages from Bioconductor
    library(BiocManager)
    BiocManager::install(yaml_packages$packages_from_Bioconductor)
} else if (args[1] == "Github") {
    # Install Github packages
    library(devtools)
    lapply(yaml_packages$packages_from_Github, devtools::install_github)
}

# Install other
#library(reticulate)
#use_virtualenv("venv")
#py_install('umap-learn', pip = T, pip_ignore_installed = T) # Ensure the latest version of UMAP is installed
#py_install("louvain", envname = "venv")

