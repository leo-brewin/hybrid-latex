#-------------------------------------------------------------------------------
SHELL = /bin/bash
#-------------------------------------------------------------------------------
.PHONY: all tests
TARGETS = $(patsubst %.tex,%,$(wildcard example-[0-9][0-9]*.tex)) mixed
#-------------------------------------------------------------------------------
all:
	@ mkdir -p pdf lib tests/output tests/expected
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
	@ cp -f mixed.pdf pdf/.
	@ cp -f mixed.pytex lib/.
	@ cp -f mixed.pytex tests/output/.
	@ touch .mixed
#-------------------------------------------------------------------------------
summary:
	@ make .summary
.summary: summary.tex
	@ echo "pdflatex summary ..."
	@ pdflatex -halt-on-error -interaction=batchmode summary &> summary.log
	@ cp -f summary.pdf pdf/.
	@ touch .summary
#-------------------------------------------------------------------------------
gallery:
	@ make .gallery
.gallery: *.pdf
	@ echo "pdflatex gallery ..."
	@ pdflatex -halt-on-error -interaction=batchmode gallery &> gallery.log
	@ cp -f gallery.pdf pdf/.
	@ touch .gallery
#-------------------------------------------------------------------------------
example-09:
	@ make .example-09
.example-09: example-09.tex
	@ echo "pdflatex example-09 ..."
	@ pdflatex -halt-on-error -interaction=batchmode example-09 &> example-09.pylog
	@ echo "pylatex.sh -i example-09 ..."
	@ pylatex.sh -s -i example-09 &> example-09.pylog
	@ cp -f example-09.pdf pdf/.
	@ cp -f example-09.pytex lib/.
	@ cp -f example-09.pytex tests/output/.
	@ touch .example-09
#-------------------------------------------------------------------------------
%:
	@ make .$*
.%:	%.tex
	@ echo "pylatex.sh $* ..."
	@ pylatex.sh -s -i $* &> $*.pylog
	@ cp -f $*.pdf pdf/.
	@ cp -f $*.pytex lib/.
	@ cp -f $*.pytex tests/output/.
	@ touch .$*
#-------------------------------------------------------------------------------
expected:
	@ for file in $(TARGETS); \
	  do \
	     cp -f tests/output/$${file}.*tex tests/expected/.; \
	  done
#-------------------------------------------------------------------------------
tests:
	@ tests.sh
#-------------------------------------------------------------------------------
rm-dot:
	@ for file in $(TARGETS) summary gallery; \
	  do \
	     rm -rf .$${file}; \
	  done
	@ rm -rf .[a-z]*.lb
#-------------------------------------------------------------------------------
rm-output:
	@ for file in $(TARGETS); \
	  do \
	     rm -rf tests/output/$${file}.*tex; \
	  done
#-------------------------------------------------------------------------------
rm-expected:
	@ for file in $(TARGETS); \
	  do \
	     rm -rf tests/expected/$${file}.*tex; \
	  done
#-------------------------------------------------------------------------------
clean:
	@ for file in $(TARGETS) summary gallery; \
	  do \
	     rm -rf $${file}.aux $${file}.log $${file}.out $${file}.synctex.gz; \
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
	@ make rm-output
	@ make rm-expected
	@ make veryclean
	@ rm -rf pdf/*.pdf lib/*.*tex
	@ for file in $(TARGETS) summary gallery; \
	  do \
	     rm -rf $${file}.pdf $${file}.txt; \
		  rm -rf $${file}.pytex $${file}.mpltex; \
	     rm -rf $${file}-fig*.pdf $${file}-fig*.png  $${file}-fig*.pgf  $${file}-fig*.jpeg; \
	  done
#-------------------------------------------------------------------------------
github-clean:
	@ make rm-dot
	@ make rm-output
	@ make veryclean
	@ for file in $(TARGETS) summary gallery; \
	  do \
	     rm -rf $${file}.pdf $${file}.txt; \
		  rm -rf $${file}.pytex $${file}.mpltex; \
	     rm -rf $${file}-fig*.pdf $${file}-fig*.png  $${file}-fig*.pgf  $${file}-fig*.jpeg; \
	  done
#-------------------------------------------------------------------------------
github:
	@ make pristine
	@ make all
	@ make expected
	@ make github-clean
