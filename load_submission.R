library(dplyr)
df <- collabin::read_gs("https://docs.google.com/spreadsheets/d/1LeDRR3iXflUDgDD5WdOjXJfLXCDtdBpetna_R6rXtH0/edit?usp=sharing")
df <- df %>% mutate(id = if_else(id %in% c('lichen'), 'yichen', id))


#View(df)
new_post <- df[nrow(df), ]
new_post

print(paste0('Format: ', new_post$format))

if (sum(df$shorturl == new_post$shorturl, na.rm=T) > 1) {
  new_post$shorturl <- paste0(new_post$shorturl, '-', sum(df$shorturl == new_post$shorturl, na.rm=T))
}

##################### Jupyter Notebook ###########################
if (new_post$format == '.ipynb') 
{
  
    postdir <- paste('content', 
                      collabin:::lookup_lope_id(new_post$id),
                      new_post$shorturl, sep = '/')
    index_fp <- paste0(postdir, '/index.ipynb')
    
    if (!dir.exists(postdir)) {
      dir.create(postdir)
    } else warning('Directory alread exist.')
    
    zip_url <- new_post$zip_path
    file_info <- collabin::download_gd(zip_url)
    
    # Test ipynb extraction
    if (file_info$isZip) {
      collabin::unzip_ipynb(file_info$fpath, postdir)
    } else {
      file.copy(file_info$fpath, index_fp)
    }
    
    # Convert ipynb to markdown
    collabin::ipynb2md(index_fp)
    #collabin::ipynb2md('content/joychiang/littlelight4/index.ipynb')
    
    # Prepend yaml header to markdown
    collabin::gsheet2post(new_post, post_dir_name = new_post$shorturl)
} 

################# R Markdown ####################
if (new_post$format == '.Rmd')
{
    postdir <- paste('content', 
                      collabin:::lookup_lope_id(new_post$id),
                      new_post$shorturl, sep = '/')
    index_fp <- paste0(postdir, '/index.Rmd')
    
    if (!dir.exists(postdir)) {
      dir.create(postdir)
    } else warning('Directory alread exist.')
    
    zip_url <- new_post$zip_path
    file_info <- collabin::download_gd(zip_url)
    
    
    # zip file extraction
    if (file_info$isZip) {
      collabin::unzip_rmd(file_info$fpath, postdir)
    } else {
      file.copy(file_info$fpath, index_fp)
    }
    
    # Prepend yaml header to markdown
    collabin::gsheet2post(new_post, post_dir_name = new_post$shorturl)
}


##################### Markdown ######################
if (new_post$format == '.md')
{
    postdir <- paste('content', 
                      collabin:::lookup_lope_id(new_post$id),
                      new_post$shorturl, sep = '/')
    index_fp <- paste0(postdir, '/index.md')
    
    if (!dir.exists(postdir)) {
      dir.create(postdir)
    } else warning('Directory alread exist.')
    
    zip_url <- new_post$zip_path
    file_info <- collabin::download_gd(zip_url)
    
    # .md extraction
    if (file_info$isZip) {
      temp <- tempfile()
      extr_fps <- unzip(file_info$fpath, exdir = temp)
      copied_fpath <- collabin:::copy_file_inzip(extr_fps, ".+\\.md$", postdir, grep = TRUE)
    } else {
      file.copy(file_info$fpath, index_fp)
    }
    
    # Prepend yaml header to markdown
    collabin::gsheet2post(new_post, post_dir_name = new_post$shorturl)
}    

# Test Rmd extraction
#collabin::unzip_rmd('~/collabin-dev/manual-test/single_index_rmd.zip', 'content/joychiang/text-zip')

