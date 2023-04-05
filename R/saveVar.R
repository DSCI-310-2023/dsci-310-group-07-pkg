#' Save the variable into file as .rds
#'
#' @param var the variable to be saved
#' @param name the expected name of variable, should followed by .rds
#' @param out_dir the location of saved variable
#'
#' @return a message of saved variable information
#'
#' @examples
#' saveVar(10,"num.rds","variable")
saveVar <- function(var, name, out_dir) {
  if (!dir.exists(out_dir)) {
    dir.create(out_dir)
  }
  saveRDS(var, file = paste0(out_dir, "/", name))
  print(paste(name, "saved to", out_dir))
  return(paste(name, "saved to", out_dir)) #return for testing purpose
}

