#!/bin/bash

file="<none>"
silent="no"
keep="no"
skiplatex="no"
Timer=""
Matlab=matlab
# Matlab="/Applications/MATLAB_R2021b.app/bin/matlab"
MatlabOpts="-nodesktop -nosplash -noFigureWindows"
sty=""
nowarn=""

# -----------------------------------------------------------------------------------------
# Parse the comatnd-line options

OPTIND=1

while getopts 'i:I:P:sktTxhN' option
do
   case "$option" in
   "i")  file="$OPTARG"      ;;
   "I")  sty="-I$OPTARG"     ;;
   "P")  Matlab="$OPTARG"    ;;
   "s")  silent="yes"        ;;
   "k")  keep="yes"          ;;
   "t")  Timer="/usr/bin/time"    ;;
   "T")  Timer="/usr/bin/time -l" ;;
   "x")  skiplatex="yes"     ;;
   "N")  nowarn="-N"         ;;
   "h")  echo "usage : matlatex.sh -i file [-P<path to Matlab>]"
         echo "                            [-I<path to matmacros.sty>] [-s] [-k] [-x] [-N] [-h]"
         echo "options :  -i file : source file (with or without .tex extension)"
         echo "           -I file : full path to matmacros.sty file"
         echo "           -P path : full path to the Matlab binary"
         echo "           -s : silent, don't open the pdf file"
         echo "           -k : keep all temporary files"
         echo "           -t : report brief cpu time"
         echo "           -T : report detailed cpu time plus memory usage"
         echo "           -x : don't call latex"
         echo "           -N : don't warn if errors found in the output for some tags"
         echo "           -h : this help message"
         echo "example : matlatex.sh -i file"
         exit                ;;
   ?)    echo "matlatex.sh : Unknown option specified."
         exit                ;;
   esac
done

# strip .tex if given
file=$(basename -s ".tex" "$file")
name=$file

if [[ $file = "<none>" ]]; then
   echo "> no source file given, use pylatex.sh -i file"
   exit 1;
fi;

if [[ ! -e $file.tex ]]; then
   echo "> file ""$file.tex"" not found, exit"
   exit 1;
fi

# does the source contain \Input?
num=$(egrep -c -e'^\s*(\\|\@|\$)Input\{' "$file".tex)

# yes, now merge source files
if ! [[ $num = 0 ]]; then
   merge-src.py -i $file.tex -o .merged.tex
   name=".merged"
fi

touch $file.mattxt

matpreproc.py -i $file -m $name           || exit 1

$Timer $Matlab $MatlabOpts -r "try, ${file}_; catch, disp('> matlab failed'), exit(1), end, quit" > $file.mattxt || (echo "> matlab failed, check ${file}_.m"; exit 3)

matpostproc.py $nowarn -i $file $sty      || exit 5

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
   rm -rf $file.log $file.out $file.m $file"_.m" $file.matidx $file.mattxt $file.matlog
fi
