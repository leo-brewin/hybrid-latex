#-------------------------------------------------------------------------------
SHELL = /bin/bash
#-------------------------------------------------------------------------------
.PHONY: all
#-------------------------------------------------------------------------------
# my licences for maple, mathematica and matlab have expired
# hence I've frozen the corresonding code by commenting out varios bit of the Makefile
# if you have a valid licence, then uncomment the matching lines
#-------------------------------------------------------------------------------
all:
	@ (echo "make all cadabra ...";           cd cadabra/examples;     make all)
	@ # (echo "make all maple ...";             cd maple/examples;       make all)
	@ # (echo "make all mathematica ...";       cd mathematica/examples; make all)
	@ # (echo "make all matlab ...";            cd matlab/examples;      make all)
	@ (echo "make all python ...";            cd python/examples;      make all)
	@ (echo "make all doc ...";               cd doc;                  make all)
#-------------------------------------------------------------------------------
install:
	@ (echo "make install ..."; INSTALL.sh)
#-------------------------------------------------------------------------------
expected:
	@ (echo "make expected cadabra ...";      cd cadabra/examples;     make expected)
	@ # (echo "make expected maple ...";        cd maple/examples;       make expected)
	@ # (echo "make expected mathematica ...";  cd mathematica/examples; make expected)
	@ # (echo "make expected matlab ...";       cd matlab/examples;      make expected)
	@ (echo "make expected python ...";       cd python/examples;      make expected)
#-------------------------------------------------------------------------------
tests:
	@ (echo "make tests cadabra ...";         cd cadabra/examples;     make tests)
	@ # (echo "make tests maple ...";           cd maple/examples;       make tests)
	@ # (echo "make tests mathematica ...";     cd mathematica/examples; make tests)
	@ # (echo "make tests matlab ...";          cd matlab/examples;      make tests)
	@ (echo "make tests python ...";          cd python/examples;      make tests)
#-------------------------------------------------------------------------------
rm-dot:
	@ (echo "make rm-dot cadabra ...";        cd cadabra/examples;     make rm-dot)
	@ # (echo "make rm-dot maple ...";          cd maple/examples;       make rm-dot)
	@ # (echo "make rm-dot mathematica ...";    cd mathematica/examples; make rm-dot)
	@ # (echo "make rm-dot matlab ...";         cd matlab/examples;      make rm-dot)
	@ (echo "make rm-dot python ...";         cd python/examples;      make rm-dot)
	@ (echo "make rm-dot doc ...";            cd doc;                  make rm-dot)
#-------------------------------------------------------------------------------
rm-output:
	@ (echo "make rm-output cadabra ...";     cd cadabra/examples;     make rm-output)
	@ # (echo "make rm-output maple ...";       cd maple/examples;       make rm-output)
	@ # (echo "make rm-output mathematica ..."; cd mathematica/examples; make rm-output)
	@ # (echo "make rm-output matlab ...";      cd matlab/examples;      make rm-output)
	@ (echo "make rm-output python ...";      cd python/examples;      make rm-output)
#-------------------------------------------------------------------------------
clean:
	@ (echo "make clean cadabra ...";         cd cadabra/examples;     make clean)
	@ # (echo "make clean maple ...";           cd maple/examples;       make clean)
	@ # (echo "make clean mathematica ...";     cd mathematica/examples; make clean)
	@ # (echo "make clean matlab ...";          cd matlab/examples;      make clean)
	@ (echo "make clean python ...";          cd python/examples;      make clean)
	@ (echo "make clean doc ...";             cd doc;                  make clean)
#-------------------------------------------------------------------------------
veryclean:
	@ (echo "make veryclean cadabra ...";     cd cadabra/examples;     make veryclean)
	@ # (echo "make veryclean maple ...";       cd maple/examples;       make veryclean)
	@ # (echo "make veryclean mathematica ..."; cd mathematica/examples; make veryclean)
	@ # (echo "make veryclean matlab ...";      cd matlab/examples;      make veryclean)
	@ (echo "make veryclean python ...";      cd python/examples;      make veryclean)
	@ (echo "make veryclean doc ...";         cd doc;                  make veryclean)
#-------------------------------------------------------------------------------
pristine:
	@ (echo "make pristine cadabra ...";      cd cadabra/examples;     make pristine)
	@ # (echo "make pristine maple ...";        cd maple/examples;       make pristine)
	@ # (echo "make pristine mathematica ...";  cd mathematica/examples; make pristine)
	@ # (echo "make pristine matlab ...";       cd matlab/examples;      make pristine)
	@ (echo "make pristine python ...";       cd python/examples;      make pristine)
	@ (echo "make pristine doc ...";          cd doc;                  make pristine)
#-------------------------------------------------------------------------------
github:
	@ (echo "make github cadabra ...";        cd cadabra/examples;     make github)
	@ # (echo "make github maple ...";          cd maple/examples;       make github)
	@ # (echo "make github mathematica ...";    cd mathematica/examples; make github)
	@ # (echo "make github matlab ...";         cd matlab/examples;      make github)
	@ (echo "make github python ...";         cd python/examples;      make github)
	@ (echo "make github doc ...";            cd doc;                  make github)
