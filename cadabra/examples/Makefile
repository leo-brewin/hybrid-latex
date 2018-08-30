#-------------------------------------------------------------------------------
SHELL = /bin/bash
#-------------------------------------------------------------------------------
.PHONY: all tests
TARGETS = $(patsubst %.tex,%,$(wildcard example-[0-9][0-9]*.tex))
#-------------------------------------------------------------------------------
all:
	@ mkdir -p pdfs tests/output tests/expected
	@ for file in $(TARGETS); do make .$${file}; done;
	@ make gallery
#-------------------------------------------------------------------------------
gallery:
	@ make .gallery
.gallery: *.pdf
	@ echo "pdflatex gallery ..."
	@ pdflatex -halt-on-error -interaction=batchmode gallery &> gallery.log
	@ touch .gallery
#-------------------------------------------------------------------------------
%:
	@ make .$*
.%:	%.tex
	@ echo "cdblatex.sh $* ..."
	@ cdblatex.sh -s -i $* &> $*.cdblog
	@ cp -f $*.cdbtex tests/output/.
	@ touch .$*
#-------------------------------------------------------------------------------
expected:
	@ for file in $(TARGETS); \
	  do \
	     cp -f $${file}.pdf pdfs/.; \
	     cp -f tests/output/$${file}.*tex tests/expected/.; \
	  done
	@ mv -f gallery.pdf pdfs/.
#-------------------------------------------------------------------------------
tests:
	@ tests.sh
#-------------------------------------------------------------------------------
rm-dot:
	@ for file in $(TARGETS) gallery; \
	  do \
	     rm -rf .$${file}; \
	     rm -rf .[a-z]*.lb; \
	  done
#-------------------------------------------------------------------------------
rm-output:
	@ for file in $(TARGETS); \
	  do \
	     rm -rf tests/output/$${file}.*tex; \
	  done
#-------------------------------------------------------------------------------
clean:
	@ for file in $(TARGETS) gallery; \
	  do \
	     rm -rf $${file}.aux $${file}.log $${file}.out $${file}.synctex.gz; \
		  rm -rf comment.cut; \
	  done
#-------------------------------------------------------------------------------
veryclean:
	@ make clean
	@ for file in $(TARGETS) gallery; \
	  do \
		  rm -rf $${file}.cdb $${file}_.cdb $${file}.cdbidx $${file}.cdbtxt $${file}.cdblog; \
		  rm -rf $${file}.pytxt $${file}.pylog; \
	  done
#-------------------------------------------------------------------------------
pristine:
	@ make rm-dot
	@ make veryclean
	@ for file in $(TARGETS) gallery; \
	  do \
	     rm -rf $${file}.pdf $${file}.txt; \
		  rm -rf $${file}.json $${file}.c; \
		  rm -rf $${file}.pytex $${file}.cdbtex; \
	     rm -rf $${file}-fig.pdf $${file}-fig.png $${file}-fig.pgf $${file}-fig.jpeg; \
		  rm -rf pdfs/*.pdf tests/output/$${file}.*tex tests/expected/$${file}.*tex; \
	  done
#-------------------------------------------------------------------------------
github:
	@ make pristine
	@ make all
	@ make expected
	@ make veryclean
	@ make rm-output
