#!/bin/bash

file="<none>"
silent="no"
keep="no"
skiplatex="no"
MMA=mathematica
# MMA="/Applications/Mathematica.app/Contents/MacOS/wolframscript"
MMAOpts="-noprompt"
sty=""
warn=""

# -----------------------------------------------------------------------------------------
# Parse the command-line options

OPTIND=1

while getopts 'i:I:P:skxhW' option
do
   case "$option" in
   "i")  file="$OPTARG"      ;;
   "I")  sty="-I$OPTARG"     ;;
   "P")  MMA="$OPTARG"       ;;
   "s")  silent="yes"        ;;
   "k")  keep="yes"          ;;
   "x")  skiplatex="yes"     ;;
   "W")  warn="-W"           ;;
   "h")  echo "usage : mmalatex.sh -i file [-P<path to Mathematica>]"
         echo "                            [-I<path to mmamacros.sty>] [-s] [-k] [-x] [-W] [-h]"
         echo "options :  -i file : source file (with or without .tex extension)"
         echo "           -I file : full path to mmamacros.sty file"
         echo "           -P path : full path to the Mathematica binary"
         echo "           -s : silent, don't open the pdf file"
         echo "           -x : don't call latex"
         echo "           -k : keep all temporary files"
         echo "           -W : warn if errors found in the output for some tags"
         echo "           -h : this help message"
         echo "exammae : mmalatex.sh -i file"
         exit                ;;
   ?)    echo "mmalatex.sh : Unknown option specified."
         exit                ;;
   esac
done

# strip .tex if given
file=$(basename -s ".tex" "$file")
name=$file

if [[ $file = "<none>" ]]; then
   echo "> no source file given, use mmalatex.sh -i file"
   exit 1;
fi;

if [[ ! -e $file.tex ]]; then
   echo "> file ""$file.tex"" not found, exit"
   exit 1;
fi

# does the source contain \Input?
num=$(egrep -c -e'^\s*\\Input\{' "$file".tex)

# yes, now merge source files
if ! [[ $num = 0 ]]; then
   merge-tex.py -i $file.tex -o .merged.tex
   name=".merged"
fi

touch $file.mmatxt

mmapreproc.py -i $file -m $name              || exit 1

$MMA $MMAOpts < $file"_.mma" > $file.mmatxt  || exit 3

mmapostproc.py $warn -i $file $sty           || exit 5

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
   rm -rf .merged.tex .tmp.txt
   rm -rf $file.log $file.out $file.mma $file"_.mma" $file.mmaidx $file.mmatxt
fi
