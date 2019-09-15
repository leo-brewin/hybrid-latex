#-------------------------------------------------------------------------------
SHELL = /bin/bash
#-------------------------------------------------------------------------------
.PHONY: all tests
TARGETS = $(patsubst %.tex,%,$(wildcard example_[0-9][0-9]*.tex)) mixed
#-------------------------------------------------------------------------------
all:
	@ mkdir -p pdfs tests/output tests/expected
	@ for file in $(TARGETS); do make .$${file}; done;
	@ make gallery
#-------------------------------------------------------------------------------
mixed:
	@ make .mixed
.mixed: mixed.tex
	@ echo "matlatex.sh -x mixed ..."
	@ matlatex.sh -x -i mixed &> mixed.matlog
	@ cp -f mixed.mattex tests/output/.
	@ echo "pylatex.sh -i mixed ..."
	@ pylatex.sh -s -i mixed &> mixed.pylog
	@ cp -f mixed.pytex tests/output/.
	@ touch .mixed
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
	@ echo "matlatex.sh $* ..."
	@ matlatex.sh -s -i $* &> $*.matlog
	@ cp -f $*.mattex tests/output/.
	@ touch .$*
#-------------------------------------------------------------------------------
expected:
	@ for file in $(TARGETS); \
	  do \
	     cp -f $${file}.pdf pdfs/.; \
	     cp -f tests/output/$${file}.*tex tests/expected/.; \
	  done
	@ cp -f gallery.pdf pdfs/.
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
	  done
#-------------------------------------------------------------------------------
veryclean:
	@ make clean
	@ for file in $(TARGETS) gallery; \
	  do \
		  rm -rf $${file}.m $${file}_.m $${file}.matidx $${file}.mattxt $${file}.matlog; \
		  rm -rf $${file}.pytxt $${file}.pylog; \
	  done
#-------------------------------------------------------------------------------
pristine:
	@ make rm-dot
	@ make veryclean
	@ for file in $(TARGETS) gallery; \
	  do \
	     rm -rf $${file}.pdf $${file}.txt; \
		  rm -rf $${file}.pytex $${file}.mattex; \
	     rm -rf $${file}_fig.pdf $${file}_fig*.png  $${file}_fig*.pgf  $${file}_fig*.jpeg; \
		  rm -rf pdfs/*.pdf tests/output/$${file}.*tex tests/expected/$${file}.*tex; \
	  done
#-------------------------------------------------------------------------------
github:
	@ make pristine
	@ make all
	@ make expected
	@ make veryclean
	@ make rm-output
