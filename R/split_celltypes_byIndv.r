#' #########################################################################
#' Split the celltypes by assinging individual ids.
#'
#' @param keptExp A list containing all the experiment samples
#' @param joinCells The celltypes to join as a single type of cells which are
#' then split into two groups of samples. i.e. cases and controls
#' @param nCases Number of individual of cases to split
#' @param jointName New name of the joined celltype
#'
#'
#' @return Returns an `outputList` which is what format and information?
#'
#' @export
split_celltypes_byIndv <- function(keptExp,joinCells=c("TEGLU1","TEGLU2"),nCases=3,jointName="Pyramidal"){

  # joinCells[1] are the 'cases' and joinCells[2] are the 'controls'
  if(length(joinCells)!=2){stop("joinCells should be only two names")}

  otherCells = setdiff(unique(colnames(keptExp)),joinCells)
  idx_otherCells = which(colnames(keptExp) %in% otherCells)
  sampleGroups = split(idx_otherCells, c("Cases","Controls"))
  idx_cases = c(sampleGroups$Cases,which(colnames(keptExp) %in% joinCells[1]))
  idx_controls = c(sampleGroups$Controls,which(colnames(keptExp) %in% joinCells[2]))
  colnames(keptExp)[colnames(keptExp) %in% joinCells] = jointName

  # Setup the case/control labels
  dx = rep("Cases",dim(keptExp)[2])
  dx[idx_controls] = "Controls"

  # Setup the individual labels
  indv_cases    = split(which(dx=="Cases"), 1:(nCases))
  indv_controls = split(which(dx=="Controls"), 1:(nCases))
  indv = c(indv_cases,indv_controls)

  # Create new list
  outputList = list()
  for(ii in 1:length(indv)){
    outputList[[ii]] = list()
    outputList[[ii]]$exp = keptExp[,indv[[ii]]]
    outputList[[ii]]$dx  = unique(dx[indv[[ii]]])
    outputList[[ii]]$ct  = colnames(outputList[[ii]]$exp)
    N = length(colnames(outputList[[ii]]$exp))
    colnames(outputList[[ii]]$exp) = sprintf("%s_%s",colnames(outputList[[ii]]$exp),1:N)
  }
  return(outputList)
}
