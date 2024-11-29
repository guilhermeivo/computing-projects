IMAGE_FILE="$(find . -name '*.png')"

rm -f ${IMAGE_FILE}

TEMP_FILE="$(find . -name '*.pdf')"

rm -f ${TEMP_FILE}

FILE_EXTENSIONS=(
    ## Bibliography auxiliary files (bibtex/biblatex/biber)
    "bbl" "bcf" "blg"
    "brf" ### hyperref
    "idx" "ilg" "ind" "ist" ### makeidx
    "glg" "glo" "gls" ### glossaries
    ## Core latex/pdflatex auxiliary files
    "aux" "lof" "log" "lot" "fls" "out" "toc" "fmt" "fot" "cb" "cb2" "lb"
    "lol"
    )


for FILE_EXTENSION in ${FILE_EXTENSIONS[@]}; do
    rm -f ${TEMP_FILE//".pdf"/".${FILE_EXTENSION}"}
done