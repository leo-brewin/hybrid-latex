#!/bin/bash

file="<none>"
silent="no"
keep="no"
skiplatex="no"
MMA=mathematica
# MMA="/Applications/Mathematica.app/Contents/MacOS/wolframscript"
MMAOpts="-noprompt"
sty=""

# -----------------------------------------------------------------------------------------
# Parse the command-line options

OPTIND=1

while getopts 'i:I:P:skxh' option
do
   case "$option" in
   "i")  file="$OPTARG"      ;;
   "I")  sty="-I$OPTARG"     ;;
   "P")  MMA="$OPTARG"       ;;
   "s")  silent="yes"        ;;
   "k")  keep="yes"          ;;
   "x")  skiplatex="yes"     ;;
   "h")  echo "usage : mmalatex.sh -i file [-P<path to Mathematica>] [-I<path to mmamacros.sty>] [-s] [-k] [-h]"
         echo "options :  -i file : source file (without .tex extension)"
         echo "           -I file : full path to mmamacros.sty file"
         echo "           -P path : where to find the Mathematica binary"
         echo "           -s : silent, don't open the pdf file"
         echo "           -x : don't call latex"
         echo "           -k : keep all temporary files"
         echo "           -h : this help message"
         echo "exammae : mmalatex.sh -i file"
         exit                ;;
   ?)    echo "mmalatex.sh : Unknown option specified."
         exit                ;;
   esac
done

if [[ ! -e $file.tex ]]; then
   echo "> file ""$file.tex"" not found, exit"
   exit 1;
fi

if [[ $file = "<none>" ]]; then
   echo "> no source file given, use mmalatex.sh -i file"
   exit 1;
fi;

file=$(basename -s ".tex" "$file")
num=$(egrep -c -e'^\s*\\Input\{' "$file".tex)
name=$file

if ! [[ $num = 0 ]]; then
   merge-tex.py -i $file.tex -o .merged.tex
   name=".merged"
fi

mmapreproc.py -i $file -m $name              || exit 1

$MMA $MMAOpts < $file"_.mma" > $file.mmatxt  || exit 3

mmapostproc.py -i $file $sty                 || exit 5

if [[ $skiplatex = "no" ]]; then
   pdflatex -halt-on-error -interaction=batchmode -synctex=1 $file || exit 7
   echo " " # for some silly reason pdfsync forgets a trailing \n
else
   silent="yes"
fi

if [[ $silent = "no" ]]; then
   open $file.pdf       # macOS
   # xdg-open $file.pdf   # Linux
   # evince $file.pdf     # Linux
fi

if [[ $keep = "no" ]]; then
   rm -rf comment.cut
   rm -rf .merged.tex .tmp.txt
   rm -rf $file.log $file.out $file.mma $file"_.mma" $file.mmaidx $file.mmatxt
fi
