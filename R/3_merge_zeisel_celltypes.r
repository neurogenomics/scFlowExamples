#' Given a list of data from each celltype, keep only the matrices from the list corresponding to cells in useCells
#'
#' \code{merge_zeisel_celltypes}
#'
#' @param allExp A list, where each entry has a matrix
#' @return A list containing $exp with the sparse matrix and $annot with annot data
#' @examples
#' # create a temporary directory
#' td = tempdir()
#'  create the placeholder file
#' tf = tempfile(tmpdir=td, fileext=".zip")
#' download into the placeholder file
#' download.file("https://storage.googleapis.com/linnarsson-lab-loom/l5_all.loom", tf)
#' zeisel2018 = prep_zeisel2018()
#' keptExp = merge_zeisel_celltypes(allExp,useCells=c("TEGLU1","TEGLU2","MGL1","MOL1"))
#' @export

# Filter `allExp` values to only those listed in `useCells` var
merge_zeisel_celltypes <- function(allExp,useCells=c("TEGLU1","TEGLU2","MGL1","MOL1")){
  exp = allExp[[useCells[1]]]
  colnames(exp) = rep(useCells[1],dim(exp)[2])
  for(ct in useCells[-1]){
    tmp = allExp[[ct]]
    colnames(tmp) = rep(ct,dim(tmp)[2])
    exp = cbind(exp,tmp)
  }
  return(exp)
}
