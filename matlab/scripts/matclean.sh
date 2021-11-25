#!/bin/bash

file="<none>"

# -----------------------------------------------------------------------------------------
# Parse the command-line options

OPTIND=1

while getopts 'hi:' option
do
   case "$option" in
   "i")  file="$OPTARG"      ;;
   "h")  echo "usage : matclean.sh -i file [-h]"
         echo "options :  -i file : source file (with or without .tex extension)"
         echo "           -h : this help messag"
         echo "example : matclean.sh -i file"
         exit                ;;
   ?)    echo "matclean.sh : Unknown option specified."
         exit                ;;
   esac
done

# strip .tex if given
file=$(basename -s ".tex" "$file")

if [[ $file = "<none>" ]]; then
   echo "> no source file given, use matclean.sh -i file"
   exit 1;
fi;

rm -rf .merged.tex .tmp.txt
rm -rf $file.log $file.out $file.mat $file"_.mat" $file.matidx $file.mattxt
