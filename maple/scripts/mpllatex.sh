#!/bin/bash

file="<none>"
silent="no"
keep="no"
skiplatex="no"
Timer=""
Maple=maple
# Maple="/Library/Frameworks/Maple.framework/Versions/Current/bin/maple"
MapleOpts=""
sty=""
nowarn=""

# -----------------------------------------------------------------------------------------
# Parse the command-line options

OPTIND=1

while getopts 'i:I:P:sktTxhN' option
do
   case "$option" in
   "i")  file="$OPTARG"      ;;
   "I")  sty="-I$OPTARG"     ;;
   "P")  Maple="$OPTARG"     ;;
   "s")  silent="yes"        ;;
   "k")  keep="yes"          ;;
   "t")  Timer="/usr/bin/time"    ;;
   "T")  Timer="/usr/bin/time -l" ;;
   "x")  skiplatex="yes"     ;;
   "N")  nowarn="-N"         ;;
   "h")  echo "usage : mpllatex.sh -i file [-P<path to Maple>]"
         echo "                            [-I<path to mplmacros.sty>] [-s] [-k] [-x] [-N] [-h]"
         echo "options :  -i file : source file (without .tex extension)"
         echo "           -I file : full path to mplmacros.sty file"
         echo "           -P path : full path to the Maple binary"
         echo "           -s : silent, don't open the pdf file"
         echo "           -k : keep all temporary files"
         echo "           -t : report brief cpu time"
         echo "           -T : report detailed cpu time plus memory usage"
         echo "           -x : don't call latex"
         echo "           -N : don't warn if errors found in the output for some tags"
         echo "           -h : this help message"
         echo "example : mpllatex.sh -i file"
         exit                ;;
   ?)    echo "mpllatex.sh : Unknown option specified."
         exit                ;;
   esac
done

# strip .tex if given
file=$(basename -s ".tex" "$file")
name=$file

if [[ $file = "<none>" ]]; then
   echo "> no source file given, use mpllatex.sh -i file"
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

touch $file.mpltxt

mplpreproc.py -i $file -m $name               || exit 1

$Timer $Maple $MapleOpts $file"_.mpl" > $file.mplout || exit 3

mplpostproc.py $nowarn -i $file $sty          || exit 5

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
   rm -rf $file.log $file.out $file.mpl $file"_.mpl" $file.mplidx $file.mpltxt $file.mplout
fi
