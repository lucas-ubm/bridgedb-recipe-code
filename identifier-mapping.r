library("BridgeDbR")
library("tidyverse")

get_mappings <- function(filepath, organism, source, target='') {
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
  return(right_join(data_df, mapping))
}
