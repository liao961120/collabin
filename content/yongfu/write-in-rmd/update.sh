
echo 'Enter 1) paged;   2) rmdformats:'
read file

if [[ $file == "1" ]]; then
    Rscript -e 'rmarkdown::render("index.Rmd", output_format="pagedown::book_crc")'
    mv index.html paged.html
    cp -r index_files *.png *.html ~/liao961120.github.io/notes/write-in-rmd/

elif [[ $file == "2" ]]; then
    Rscript -e 'rmarkdown::render("index.Rmd", output_format="rmdformats::readthedown")'
    cp index.html ~/liao961120.github.io/notes/write-in-rmd/rmdformats.html

else 
    echo "Please enter '1' or '2'"
    echo "No file copied."
fi


# Preview Site
echo 'Serve Site?'
echo "'y' or 'n'"
read serve

if [[ $serve == 'y' || $serve == 'Y' ]]; then
    python3 -m http.server &
    if [[ $file == "1" ]]; then
        chromium-browser http://0.0.0.0:8000/paged.html
    else
        chromium-browser http://0.0.0.0:8000/
    fi
else
    echo 'Closing ...'
fi