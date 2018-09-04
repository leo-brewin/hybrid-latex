# Hybrid LaTeX - adding active language blocks to LaTeX

## Overview

This is a collection of Python and Bash shell scripts that allows LaTeX documents to contain active blocks of code including Python, Maple, Mathematica, Matlab and Cadabra. The active code blocks are processed ahead of LaTeX and their results are accessible within the same LaTeX document. Thus a calculation that might otherwise be done using in two documents, one using Mathematica to do the maths, and a separate LaTeX document to record the results can be consolidated into a single source.

There are other collections that achieve the same result, see [PyhtonTeX][1] and [SageTeX][2] .

The main advantages of this collection over PyhtonTeX and SageTeX are:

  * The tools are written in Python and Bash rather than LaTeX, thus allowing easy extension to other languages,
  * The results of the active code blocks are saved to a single file that can be easily shared with colleagues, journals or included in other LaTeX documents, and

## Installation

There are a handful of files to install (by hand) for each language. These include Bash shell scripts, Python scripts and LaTeX style files. Each file can be copied to wherever their respective program expects to find them. For example, the Bash and Python scripts could be sudo copied to `/usr/local/bin` (for access by all users) or to `~/bin` (for your personal access). The LaTeX style files can be copied to wherever they will be visible to LaTeX (see [this discussion][3] on tex.stackexchange for useful suggestions). If you place the files in non-standard locations you may need to adjust your `PATH` and `TEXINPUT` environment variables accordingly. If all else fails, you can copy all of the Bash, Python and LaTeX files into the same directory as your LaTeX document (though this is a very bad solution).

More details on the installation can be found in the main documentation, `doc/hybrid.pdf`.

## Maple, Mathematica and Matlab

These programs are normally run from within a GUI. But the Bash scripts provided here will run each each of these from the command line. The scripts currently look for executables named "maple", "mathematica" and "matlab" (without the double-quotes). You may need to adjust your `PATH` variable to include these executables or create appropriate soft-links from say `~/bin` to point to the actual executables. As a final option you can add the `-P<path>` command line option when invoking the shell script. For example, on macOS, a Matlab-LaTeX source could be compiled using

    $ matlatex.sh -i foo -P/Applications/MATLAB_R2018a.app/bin/matlab

The corresponding commands for Mathematica and Maple (on macOS) are:

    $ mmalatex.sh -i foo -P/Applications/Mathematica.app/Contents/MacOS/wolframscript
    $ mpllatex.sh -i foo -P/Library/Frameworks/Maple.framework/Versions/Current/bin/maple

Note that the shell scripts (`matlatex.sh`, `mpllatex.sh` etc.) can be edited so that the default value for `-P` is the full path to the correct executable.

## Documentation

The main documentation can be found in `doc/hybrid.pdf`. It is written mostly in the context of a Python-LaTeX document. The changes required for other languages are very minor (and are mostly just changing which scripts to run/include and names of LaTeX macros).

There is also a set of examples in each of the language directories. See, for example, `python/examples/`.

## Testing

Each language directory also contains an `examples/tests/` directory with copies of the expected output (in `examples/tests/expected/`). To run the tests for Mathematica, for example, open a command line window and run

    $ cd mathematica/examples
    $ make
    $ tests.sh

The only output from the `tests.sh` command should be for `example-07`. The differences reported will be the dates and times of the job and can be safely ignored.

The pdfs of the expected results can be found in `examples/pdfs`.

## License

All files in this collection are distributed under the [MIT][4] license. See the file LICENSE.txt for the full details.

  [1]: https://github.com/gpoore/pythontex
  [2]: https://github.com/sagemath/sagetex
  [3]: https://tex.stackexchange.com/questions/1137/where-do-i-place-my-own-sty-or-cls-files-to-make-them-available-to-all-my-te
  [4]: https://opensource.org/licenses/MIT
