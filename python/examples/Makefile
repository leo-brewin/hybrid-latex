#-------------------------------------------------------------------------------
SHELL = /bin/bash
#-------------------------------------------------------------------------------
.PHONY: all tests
TARGETS = $(patsubst %.tex,%,$(wildcard example-[0-9][0-9]*.tex)) mixed
#-------------------------------------------------------------------------------
all:
	@ mkdir -p pdfs tests/output tests/expected
	@ for file in $(TARGETS); do make .$${file}; done;
	@ make summary
	@ make gallery
#-------------------------------------------------------------------------------
mixed:
	@ make .mixed
.mixed: mixed.tex
	@ echo "mpllatex.sh -x mixed ..."
	@ mpllatex.sh -x -i mixed &> mixed.mpllog
	@ cp -f mixed.mpltex tests/output/.
	@ echo "pylatex.sh -i mixed ..."
	@ pylatex.sh -s -i mixed &> mixed.pylog
	@ cp -f mixed.pytex tests/output/.
	@ touch .mixed
#-------------------------------------------------------------------------------
summary:
	@ make .summary
.summary: summary.tex
	@ echo "pdflatex summary ..."
	@ pdflatex -halt-on-error -interaction=batchmode summary &> summary.log
	@ touch .summary
#-------------------------------------------------------------------------------
gallery:
	@ make .gallery
.gallery: *.pdf
	@ echo "pdflatex gallery ..."
	@ pdflatex -halt-on-error -interaction=batchmode gallery &> gallery.log
	@ touch .gallery
#-------------------------------------------------------------------------------
example-09:
	@ make .example-09
.example-09: example-09.tex
	@ echo "pdflatex example-09 ..."
	@ pdflatex -halt-on-error -interaction=batchmode example-09 &> example-09.pylog
	@ echo "pylatex.sh -i example-09 ..."
	@ pylatex.sh -s -i example-09 &> example-09.pylog
	@ cp -f example-09.pytex tests/output/.
	@ touch .example-09
#-------------------------------------------------------------------------------
%:
	@ make .$*
.%:	%.tex
	@ echo "pylatex.sh $* ..."
	@ pylatex.sh -s -i $* &> $*.pylog
	@ cp -f $*.pytex tests/output/.
	@ touch .$*
#-------------------------------------------------------------------------------
expected:
	@ for file in $(TARGETS); \
	  do \
	     mv -f $${file}.pdf pdfs/.; \
	     mv -f tests/output/$${file}.*tex tests/expected/.; \
	  done
	@ mv -f summary.pdf pdfs/.
	@ mv -f gallery.pdf pdfs/.
#-------------------------------------------------------------------------------
tests:
	@ tests.sh
#-------------------------------------------------------------------------------
rm-dot:
	@ for file in $(TARGETS) summary gallery; \
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
	@ for file in $(TARGETS) summary gallery; \
	  do \
	     rm -rf $${file}.aux $${file}.log $${file}.out $${file}.synctex.gz; \
		  rm -rf comment.cut; \
	  done
#-------------------------------------------------------------------------------
veryclean:
	@ make clean
	@ for file in $(TARGETS) summary gallery; \
	  do \
		  rm -rf $${file}.py $${file}_.py $${file}.pyidx $${file}.pytxt $${file}.pylog $${file}.json; \
		  rm -rf $${file}.mpltxt $${file}.mpllog; \
	  done
#-------------------------------------------------------------------------------
pristine:
	@ make rm-dot
	@ make veryclean
	@ for file in $(TARGETS) summary gallery; \
	  do \
	     rm -rf $${file}.pdf $${file}.txt; \
		  rm -rf $${file}.pytex $${file}.mpltex; \
	     rm -rf $${file}-fig.pdf $${file}-fig.png  $${file}-fig.pgf  $${file}-fig.jpeg; \
		  rm -rf pdfs/*.pdf tests/output/$${file}.*tex tests/expected/$${file}.*tex; \
	  done
