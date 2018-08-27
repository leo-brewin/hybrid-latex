#!/bin/bash

file="<none>"
silent="no"
keep="no"
skiplatex="no"
Matlab=matlab
# Matlab="/Applications/MATLAB_R2018a.app/bin/matlab"
MatlabOpts="-nodesktop -nosplash -noFigureWindows"
sty=""

# -----------------------------------------------------------------------------------------
# Parse the comatnd-line options

OPTIND=1

while getopts 'i:I:P:skxh' option
do
   case "$option" in
   "i")  file="$OPTARG"      ;;
   "I")  sty="-I$OPTARG"     ;;
   "P")  Matlab="$OPTARG"    ;;
   "s")  silent="yes"        ;;
   "k")  keep="yes"          ;;
   "x")  skiplatex="yes"     ;;
   "h")  echo "usage : matlatex.sh -i file [-P<path to Matlab>] [-I<path to matmacros.sty>] [-s] [-k] [-h]"
         echo "options :  -i file : source file (without .tex extension)"
         echo "           -I file : full path to matmacros.sty file"
         echo "           -P path : where to find the Matlab binary"
         echo "           -s : silent, don't open the pdf file"
         echo "           -x : don't call latex"
         echo "           -k : keep all temporary files"
         echo "           -h : this help message"
         echo "examate : matlatex.sh -i file"
         exit                ;;
   ?)    echo "matlatex.sh : Unknown option specified."
         exit                ;;
   esac
done

if [[ ! -e $file.tex ]]; then
   echo "> file ""$file.tex"" not found, exit"
   exit 1;
fi

if [[ $file = "<none>" ]]; then
   echo "> no source file given, use matlatex.sh -i file"
   exit 1;
fi;

file=$(basename -s ".tex" "$file")
num=$(egrep -c -e'^\s*\\Input\{' "$file".tex)
name=$file

if ! [[ $num = 0 ]]; then
   merge-tex.py -i $file.tex -o .merged.tex
   name=".merged"
fi

touch $file.mattxt

matpreproc.py -i $file -m $name           || exit 1

$Matlab $MatlabOpts -r "try, ${file}_; catch, disp('> matlab failed'), exit(1), end, quit" > $file.mattxt || (echo "> matlab failed, check ${file}_.m"; exit 3)

matpostproc.py -i $file $sty              || exit 5

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
   rm -rf $file.log $file.out $file.m $file"_.m" $file.matidx $file.mattxt $file.matlog
fi
