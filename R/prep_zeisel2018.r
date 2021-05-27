#' Prep the zeisel2018 dataset so that it is in sparse matrix format
#'
#' \code{prep_zeisel2018} Loads the Zeisel2018 dataset in Loom format and converts to sparse matrix
#'
#' @param path Path to the loom file
#' @return A list containing $exp with the sparse matrix and $annot with annot data
#' @examples
#'\dontrun{
#' # create a temporary directory
#' td = tempdir()
#'  create the placeholder file
#' tf = tempfile(tmpdir=td, fileext=".zip")
#' download into the placeholder file
#' download.file("https://storage.googleapis.com/linnarsson-lab-loom/l5_all.loom", tf)
#' zeisel2018 = prep_zeisel2018()
#' }
#' @export
#' @import tidyverse
#' @import rhdf5
#' @import snow
#' @import loomR
#' @import Matrix
prep_zeisel2018 <- function(path){  # path = "/tmp/RtmpNOIeFH/file1b36daccfe5c.zip"
 # module load hdf5/1.10.4
  # wget https://storage.googleapis.com/linnarsson-lab-loom/l5_all.loom
  # Data from: http://mousebrain.org/downloads.html

  # Create the lfile by getting attributes (ClusterName, Gene, SampleID, Sex)
  # What does 'unique' do on line 40?
  lfile <- connect(filename = path, mode = "r+")
  Lvl5=lfile$col.attrs$ClusterName[]
  genes=lfile$row.attrs$Gene[]
  sample=lfile$col.attrs$SampleID[]
  sex=lfile$col.attrs$Sex[]
  cts = unique(Lvl5)

  Sys.setenv('R_MAX_VSIZE'=999000000000)

  # Get the expression data for each cell type
  # What is the `ct` variable - a count? of what? 
  get_exp <- function(ct,lfile){

    Lvl5=lfile$col.attrs$ClusterName[]
    whichCT = Lvl5==ct
    exp = Matrix::Matrix(t(lfile[["matrix"]][whichCT,]))
    rownames(exp) = lfile$row.attrs$Gene[]
    return(exp)
  }
  allExp = lapply(as.list(cts),get_exp,lfile=lfile)
  names(allExp)=cts

  return(allExp)
}
