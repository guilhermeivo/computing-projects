#!/bin/bash

set -e


MAX_ANGLE=45
MAX_INPUT=90

save_var() {
    echo "%% VAR" > var.tex
    echo "\\def\\rotationX{$1}" >> var.tex
    echo "\\def\\rotationY{$2}" >> var.tex
    echo "\\def\\rotationZ{$3}" >> var.tex
}

save_var 0 0 0

mkdir -p frames
mkdir -p temp

for i in $(seq $MAX_INPUT)
do
    save_var 0 -$i 0
    pdflatex -shell-escape -output-directory="temp" -jobname="tangent--"$i tangent.tex
    convert -density 300 temp/tangent--$i.pdf -quality 300 -background white -flatten -alpha off  frames/tangent--$(printf '%03d' "$i").png
done

cd frames
ffmpeg -y -framerate 30 -pattern_type glob -i '*.png' \
  -c:v libx264 "../tangent.mp4"
#convert -background white -alpha remove -layers OptimizePlus -delay 5 -loop 0 `ls -v` "../tangent.gif"
cd ..

mv frames/tangent--001.png thumbnail.png