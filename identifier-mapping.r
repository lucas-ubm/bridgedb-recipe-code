library("BridgeDbR")
library("tidyverse")

get_mappings <- function(filepath, organism, source, target='') {
  zm_df <- read_tsv(filepath, col_names=FALSE)
  
  if (dim(zm_df)[1] > 1){
    colnames(zm_df) <- c('identifier')
  } else {
    colnames(zm_df) <- c('local', 'identifier')
  }
    
  
  zm_df$source = source
  
  location <- getDatabase(organism)
  mapper <- loadDatabase(location)
  
  mapping = maps(mapper, zm_df, target=target)
  return(right_join(zm_df, mapping))
}

sum(zm_df$identifier %in% mapping$identifier)/lengths(zm_df)["identifier"]

zm_df["identifier", "source"]