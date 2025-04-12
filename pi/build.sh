#!/bin/bash
set -e

# cria a documentacao (experiments_wth_pi.pdf)

while getopts ri flag
do
    case "${flag}" in
        r) 
            RECREATE_DATA=TRUE
        ;;
    esac
done

FOLDER="generated/"
DATA_FOLDER="data/"
DOCSTRIP="experiments_with_pi"
BIN="$FOLDER""experiments_with_pi"
MAX=100

yes | tex $DOCSTRIP.ins 

R -e "source('data/script_convergence.R'); source('data/script_histogram.R'); source('data/script_timerun.R');"

pdflatex --draftmode $DOCSTRIP.dtx

pdflatex --draftmode experiments_with_pi.dtx
bibtex experiments_with_pi
pdflatex --draftmode experiments_with_pi.dtx

echo ''
echo '#################################################'
echo '############ Last execution pdflatex ############'
echo '#################################################'
echo ''

pdflatex experiments_with_pi.dtx

mkdir -p output
rm -f output/$DOCSTRIP.pdf
mv $DOCSTRIP.pdf output/$DOCSTRIP.pdf

exit 0
