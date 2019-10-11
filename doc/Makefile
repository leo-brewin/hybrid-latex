#-------------------------------------------------------------------------------
SHELL = /bin/bash
#-------------------------------------------------------------------------------
.PHONY: all
#-------------------------------------------------------------------------------
TARGETS = $(patsubst %.tex,%,$(wildcard hybrid.tex))
#-------------------------------------------------------------------------------
all:
	@ for file in $(TARGETS); do make .$${file}; done;
#-------------------------------------------------------------------------------
%:
	@ make .$*
.%:	%.tex
	@ echo "pdflatex.sh $* ..."
	@ touch $*.aux
	@ pdflatex -halt-on-error -interaction=batchmode $* &> $*.tmplog
	@ pdflatex -halt-on-error -interaction=batchmode $* &> $*.tmplog
	@ touch .$*
#-------------------------------------------------------------------------------
rm-dot:
	@ for file in $(TARGETS); \
	  do \
	     rm -rf .$${file}; \
	  done
	@ rm -rf .[a-z]*.lb
#-------------------------------------------------------------------------------
clean:
	@ for file in $(TARGETS); \
	  do \
	     rm -rf $${file}.log $${file}.out $${file}.tmplog $${file}.synctex.gz; \
	  done
#-------------------------------------------------------------------------------
veryclean:
	@ make clean
	@ for file in $(TARGETS); \
	  do \
	     rm -rf $${file}.aux $${file}.toc; \
	  done
#-------------------------------------------------------------------------------
pristine:
	@ make rm-dot
	@ make veryclean
	@ for file in $(TARGETS); \
	  do \
	     rm -rf $${file}.pdf; \
	  done
#-------------------------------------------------------------------------------
# prepare files for github
github:
	@ make pristine
	@ make all
	@ make veryclean
