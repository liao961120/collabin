library(magrittr)
str_match <- function(...) stringr::str_match(...)

# Loop over Rmd files to match library(<pkg>)
rmd_files <- list.files(pattern = '[Rr]md$', recursive = T)

used_pkgs <- vector("list", length(rmd_files))
for (i in seq_along(rmd_files)) {
  rscpt_path <- knitr::purl(rmd_files[[i]])
  raw <- readLines(rscpt_path, encoding = 'utf-8')
  file.remove(rscpt_path)
  
  libs <- str_match(raw, 'library\\((.+)\\)')[,2] %>%
    na.omit()
  
  if (length(libs) == 0) libs <- NA_character_
  used_pkgs[[i]] <- libs
}

used_pkgs <- unlist(used_pkgs) %>% .[!is.na(.)] %>% 
  unique()

need_install <- !(used_pkgs %in% rownames(installed.packages()))

writeLines(used_pkgs[need_install], 'need_install.txt')
