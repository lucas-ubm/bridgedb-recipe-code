library("BridgeDbR")
library("tidyverse")

get_mappings <- function(filepath, organism, source, target='') {
  # filepath indicates the path to the file containing the identifiers to be mapped
  # organism is the organism these identifiers are describing
  # source is the system code for the data source of the identifiers
  # target is an optional parameter indicating the data source to which we are mapping

  data_df <- read_tsv(filepath, col_names=FALSE)
  if (dim(data_df)[2] == 1){
    colnames(data_df) <- c('identifier')
  } else {
    colnames(data_df) <- c('local', 'identifier')
  }
    
  
  data_df$source = source
  
  location <- getDatabase(organism)
  mapper <- loadDatabase(location)
  
  if (nchar(target) == 0) {
    mapping = maps(mapper, data_df)
  }

  else{
    mapping = maps(mapper, data_df, target=target
  }
  return(right_join(data_df, mapping))
}
