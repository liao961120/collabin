library(magrittr)
## Helper
str_match <- function(...) stringr::str_match(...)
map <- function(...) purrr::map(...)
rmd2chr <- function(rmd_path) {
  rscpt_path <- knitr::purl(rmd_path)
  raw <- readLines(rscpt_path, encoding = 'utf-8')
  file.remove(rscpt_path)
  return(raw)
}
check_len <- function(chr) {
  if (length(chr) == 0) return('no-pkg-detected')
  else return(chr)
}

## Find out used pkgs from 'library'
used_pkgs <- list.files(pattern = '[Rr]md$', recursive = T) %>%
  map(rmd2chr) %>%
  unlist() %>%
  str_match('library\\((.+)\\)') %>% .[,2] %>%
  unique() %>%
  na.omit() %>%
  check_len()

cur_pkgs <- c(rownames(installed.packages()), 'no-pkg-detected')
writeLines(used_pkgs[!(used_pkgs %in% cur_pkgs)], 'need_install.txt')

pkg_lst <- readLines('need_install.txt')
if (length(pkg_lst) != 0) {
  cat('Installing packages detected in Rmd ...', 
      'If errored, check `need_install.txt` for GitHub dep.', 
      sep = '\n')
  install.packages(pkg_lst)
}