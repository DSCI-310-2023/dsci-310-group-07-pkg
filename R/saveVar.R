#' Save the variable into file as .rds
#' @importFrom here here
#' @param var the variable to be saved
#' @param name the expected name of variable, should followed by .rds
#' @param out_dir the location of saved variable
#'
#' @return a message of saved variable information
#' @export
#' @examples
#' #saveVar(10,"num.rds","saved")
saveVar <- function(var, name, out_dir) {

  # stop if the file name and path not valid
  stopifnot("name and out_dir should be strings" = is.character(name) & is.character(out_dir))
  stopifnot("name should end with .rds" = grepl("\\.rds$", name))
  full_dir <- here::here(out_dir)
  if (!dir.exists(full_dir)) {
    dir.create(full_dir)
  }
  saveRDS(var, file = paste0(full_dir, "/", name))
  print(paste(name, "saved to", full_dir))
  return(paste(name, "saved to", out_dir)) #return for testing purpose
}

