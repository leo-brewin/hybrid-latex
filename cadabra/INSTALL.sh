#!/bin/bash

# defaults, edit to suit

if [[ $HERE = '' ]]; then
   HERE=$HOME/local/hybrid-latex/
fi;

MyBin=$HERE/bin/
MyTex=$HERE/tex/

# Parse the command-line options

while getopts 'b:t:h' option
do
   case "$option" in
   "b")  MyBin="$OPTARG"      ;;
   "t")  MyTex="$OPTARG"      ;;
   "h")  echo "usage : INSTALL.sh [-bBIN] [-tTEX]"
         echo "options : -b : where to find the shell scripts"
         echo "          -t : where to find the LaTeX files "
         echo "          -h : this help message"
         exit                 ;;
   ?)    echo "INSTALL.sh: Unknown option specified."
         exit                 ;;
   esac
done

mkdir -p $MyBin $MyTex

cp -rf scripts/* $MyBin
cp -rf latex/*   $MyTex
