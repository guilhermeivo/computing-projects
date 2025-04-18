#!/bin/bash
set -e

COMPILER_VERSION=5.0.0
AOCC_FOLDER=/tmp/aocc
FOLDER="generated"

CLANG=$AOCC_FOLDER/aocc-compiler-${COMPILER_VERSION}/bin/clang
GCC=gcc

export LD_LIBRARY_PATH=$AOCC_FOLDER/aocc-compiler-${COMPILER_VERSION}/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$AOCC_FOLDER/aocc-compiler-${COMPILER_VERSION}/lib32:$LD_LIBRARY_PATH

OUTPUT_FILES=("gcc__default" "clang__default" "clang__lld")
METHODS=("m" "t" "s")

OUTPUT_DEFAULT=$FOLDER/${OUTPUT_FILES[0]}

$GCC $FOLDER/experiments_with_pi.c -Wall -O3 -lmpfr -lgmp -o $OUTPUT_DEFAULT

#---------------------------------------------

printf " -- Monte Carlo Convergence -- "
MAX=1000
for i in $(seq $MAX)
do
    printf "$i $("$OUTPUT_DEFAULT" c $i 2>/dev/null | tail -1 )\n"
done > $FOLDER/pi_monteCarlo_convergence.dat

printf " -- Monte Carlo Histogram -- "
MAX=200
for i in $(seq $MAX)
do
    printf "$i $("$OUTPUT_DEFAULT" c 100000 2>/dev/null | tail -1 )\n"
    # TODO: ajustar `sleep` para otimizar tempo de execucao
    sleep 1 # para dar tempo de gerar outra seed :)
done > $FOLDER/pi_monteCarlo_histogram.dat

printf " -- Takano -- "

MAX=100
out=$("$OUTPUT_DEFAULT" t $MAX | cut -c1-"$(expr $MAX + 2)" | sed -E -e :a -e 's/(.*[0-9])([0-9]{5})/\1 \\;\\allowbreak \2/;ta')
echo "\noindent\$\pi_{$MAX}=$out\$" > $FOLDER/pi_takano.tex

#printf " -- Save Pi -- "

#MAX=100000
#out=$("$OUTPUT_DEFAULT" s $MAX | cut -c1-"$(expr $MAX + 2)")
#echo "$out" > $FOLDER/pi_$MAX.tex

printf " -- Takano Time Run -- "

$GCC -DDEBUG $FOLDER/experiments_with_pi.c -Wall -O3 -lgmp -lmpfr -o "${OUTPUT_DEFAULT}"
$GCC -DDEBUG -DNUMBER_THREADS=$(nproc --all) $FOLDER/experiments_with_pi.c -Wall -O3 -lgmp -lmpfr -lpthread -o "${OUTPUT_DEFAULT}_multithread"

MAX=10000
printf "i\ttime_single\ttime_multi\n" > "$FOLDER/takano_timerun.dat"
for i in $(seq 0 100 $MAX)
do
    printf "$i\t"
    printf "$("${OUTPUT_DEFAULT}" t $i 2>/dev/null | tail -2 | egrep -o '[0-9.]+')\t"
    printf "$("${OUTPUT_DEFAULT}_multithread" t $i 2>/dev/null | tail -2 | egrep -o '[0-9.]+')"
    printf "\n"
done >> "$FOLDER/takano_timerun.dat"

$CLANG -DDEBUG $FOLDER/experiments_with_pi.c -I/usr/local/include -L/usr/local/lib -Wall -O3 -lmpfr -lgmp -o $FOLDER/${OUTPUT_FILES[1]}
$CLANG -DDEBUG -fuse-ld=lld $FOLDER/experiments_with_pi.c -I$AOCC_FOLDER/aocc-compiler-${COMPILER_VERSION}/include -I/usr/local/include -L/usr/local/lib -Wall -O3 -lamdlibm -lm -lmpfr -lgmp -o $FOLDER/${OUTPUT_FILES[2]} -fuse-ld=lld

MAX=200
for OUTPUT_FILE in "${OUTPUT_FILES[@]}"
do
    printf " -- $OUTPUT_FILE -- "

    printf "time\n" > "$FOLDER/$OUTPUT_FILE.dat"
    for i in $(seq $MAX)
    do
        printf "$(./$FOLDER/$OUTPUT_FILE t 10000 2>/dev/null | tail -2 | egrep -o '[0-9.]+')\n"
    done >> "$FOLDER/$OUTPUT_FILE.dat"
done

echo "$(nproc --all)\ignorespaces" > "$FOLDER/number_threads.txt"