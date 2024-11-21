#!/bin/bash

set -e

while getopts ri flag
do
    case "${flag}" in
        r) 
            RECREATE_DATA=TRUE
        ;;
        i) 
            INSTALL_PACKAGES=TRUE
        ;;
    esac
done

if [ ! -z "$INSTALL_PACKAGES" ]; 
then
    apt-get update
    apt-get install -y libgmp3-dev libmpfr-dev
fi

FOLDER="generated/"
DATA_FOLDER="data/"
DOCSTRIP="experiments_with_pi"
BIN="$FOLDER""experiments_with_pi"
MAX=100

yes | tex $DOCSTRIP.ins 
gcc "$FOLDER"experiments_with_pi.c -Wall -lmpfr -lgmp -o $BIN

if [ ! -z "$RECREATE_DATA" ]; 
then
    # Monte carlo datas
    MAX=1000
    for i in $(seq $MAX)
    do
        printf "$i $("$BIN" c $i 2>/dev/null | tail -1 )\n"
    done > "$FOLDER""pi_monteCarlo_convergence.dat"

    for i in $(seq $MAX)
    do
        printf "$i $("$BIN" c 100000 2>/dev/null | tail -1 )\n"
        sleep 1 # para dar tempo de gerar outra seed :)
    done > "$FOLDER""pi_monteCarlo_histogram.dat"

    MAX=100
    for i in $(seq $MAX)
    do
        printf "$i $("$BIN" m $i | cut -c1-"$(expr $i + 2)" 2>/dev/null | tail -1 )\n"
    done > "$FOLDER""pi_machin.dat"

    MAX=100
    out=$("$BIN" m $MAX | cut -c1-"$(expr $MAX + 2)" | sed -E -e :a -e 's/(.*[0-9])([0-9]{5})/\1 \\;\\allowbreak \2/;ta')
    echo "\noindent\$\pi_{$MAX}=$out\$" > "$FOLDER""pi_machin.tex"

    MAX=10000
    out=$("$BIN" t $MAX | cut -c1-"$(expr $MAX + 2)" | sed -E -e :a -e 's/(.*[0-9])([0-9]{5})/\1 \\;\\allowbreak \2/;ta')
    echo "\noindent\$\pi_{$MAX}=$out\$" > "$FOLDER""pi_takano.tex"

    MAX=10000
    out=$("$BIN" s $MAX | cut -c1-"$(expr $MAX + 2)" | sed -E -e :a -e 's/(.*[0-9])([0-9]{5})/\1 \\;\\allowbreak \2/;ta')
    echo "\noindent\$\pi_{$MAX}\;=\;$out\$" > "$FOLDER""pi_stormer.tex"
fi

R -e "source('script.R')"

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
