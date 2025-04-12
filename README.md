# Hybrid LaTeX - adding active language blocks to LaTeX

## Overview

This is a collection of Python and Bash shell scripts that allows LaTeX documents to contain active blocks of code including Python, Maple, Mathematica, Matlab and Cadabra. The active code blocks are processed ahead of LaTeX and their results are accessible within the same LaTeX document. Thus a calculation that might otherwise be done using two documents, one using Mathematica to do the maths, and a separate LaTeX document to record the results can be consolidated into a single source.

There are other collections that achieve the same result, see [PyhtonTeX][1] and [SageTeX][2] .

The main differences between this package and PyhtonTeX/SageTeX are:

  * The tools are written in Python and Bash rather than LaTeX, thus allowing easy extension to other languages,
  * The results of the active code blocks are saved to a single file that can be easily shared with colleagues, journals or included in other LaTeX documents.

## Installation

The simplest way to install the hybrid latex files is to run the command

````sh
$ source SETPATHS
$ make install
````

from the top directory. This will copy the files to newly created directories while also adjusting the various paths to make these files visible to LaTeX, Maple, Mathematic etc. The files, the new directories and their associated paths are as given in the following table.

|  Directory  | Content | Path variable |
|:------------:|:--------|:-------------|
| `$HOME/local/hybrid-latex/bin/` | Python and Shell scripts | `$PATH` |
| `$HOME/local/hybrid-latex/lib/` | Python libraries | `$PYTHONPATH` |
| `$HOME/local/hybrid-latex/tex/` | LaTeX files | `$TEXINPUTS` |

The command `source SETPATHS` will __prepend__ the directories to the appropriate paths while the command `make install` copies the files to their destinations. If you need to recover the original paths, just run `source OLDPATHS`.

If you prefer to install the hybrid latex files in some other directory then you can run the command

````sh
$ source SETPATHS /full/path/to/dir/
$ make install
````

where /full/path/to/dir/ is the full path to your prefered directory. The `bin`, `lib` and `tex` directories will be ceated underneath this directory.

More details on the installation can be found in the main documentation, `doc/hybrid.pdf`.

## Uninstall

The hybrid latex tools can be uninstalled by deleting the directory `$HOME/local/hybrid-latex/` (or the approrpriate directory if you chose a non-default installation).

## Maple, Mathematica and Matlab

These programs are normally run from within a GUI. But the Bash scripts provided here will run each each of these from the command line. The scripts currently look for executables named "maple", "mathematica" and "matlab" (without the double-quotes). You may need to adjust your `PATH` variable to include these executables or create appropriate soft-links from say `~/bin` to point to the actual executables. As a final option you can add the `-P<path>` command line option when invoking the shell script. For example, on macOS, a Matlab-LaTeX source could be compiled using

````sh
$ matlatex.sh -i foo -P/Applications/MATLAB_R2018a.app/bin/matlab
````

The corresponding commands for Mathematica and Maple (on macOS) are:

````sh
$ mmalatex.sh -i foo -P/Applications/Mathematica.app/Contents/MacOS/wolframscript
$ mpllatex.sh -i foo -P/Library/Frameworks/Maple.framework/Versions/Current/bin/maple
````

Note that the shell scripts (`matlatex.sh`, `mpllatex.sh` etc.) can be edited so that the default value for `-P` is the full path to the correct executable.

## Documentation

The main documentation can be found in `doc/hybrid.pdf`. It is written mostly in the context of a Python-LaTeX document. The changes required for other languages are very minor (and are mostly just changing which scripts to run/include and names of LaTeX macros).

There is also a set of examples in each of the language directories. See, for example, `python/examples/`.

## Testing

Each language directory also contains an `examples/tests/` directory with copies of the expected output (in `examples/tests/expected/`). To run the tests for Mathematica, for example, open a command line window and run

````sh
$ cd mathematica/examples
$ make
$ tests.sh
````

The only output from the `tests.sh` command should be for `example-07`. The differences reported will be the dates and times of the job and can be safely ignored.

The pdfs of the expected results can be found in `examples/pdf`.

## Dependencies

The bare minimum is an up to date versions of LaTeX and Python3. This will allow you to work through all of the Python examples. But if you wish to play with the [Maple][3], [Mathematica][4], [Matlab][5] and [Cadabra][6] examples you will also need to install their respective applications.

The examples in the Python directory do use some Python modules. See the file `python/REQUIRES.txt` for a list of modules and the version numbers that were used in developing these examples. Note that these Python modules are only used by these examples and are not required for the main hybrid latex codes.

### LaTeX

If by some small chance you do not have LaTeX already installed then you should pop over to the [TeX Live website][7].

### Python

A popular distribution of Python3 can be found at the [Anaconda website][8].

## License

All files in this collection are distributed under the [MIT][9] license. See the file LICENSE.txt for the full details.

  [1]: https://github.com/gpoore/pythontex
  [2]: https://github.com/sagemath/sagetex
  [3]: https://www.maplesoft.com
  [4]: https://www.wolfram.com/mathematica
  [5]: https://www.mathworks.com/
  [6]: https://github.com/kpeeters/cadabra2
  [7]: https://www.tug.org/texlive/
  [8]: https://www.anaconda.com/products/individual
  [9]: https://opensource.org/licenses/MIT
