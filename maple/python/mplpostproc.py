#!/usr/local/bin/python3

import re
import sys
import os.path

import enum

class Type (enum.Enum):
   BegTag    = 1
   EndTag    = 2
   PlainText = 3
   Unknown   = 4

def empty_line (this_line):
   if len(this_line) == 0:
      return True
   else:
      return re.search ("(^ *$)",this_line)

def get_index (this_line):
   result = re.search ("tag([0-9]+)",this_line)
   if result:
      return int(result.group (1))
   else:
      print ("> Error reading tag index on: " + this_line)
      sys.exit (1)

def get_text (this_line):
   result = re.search ("tag([0-9]+)=(.*)",this_line)
   if result:
      return result.group (2)
   else:
      print ("> Error reading tag text on: " + this_line)
      sys.exit (1)

def get_tag (this_line):
   return tag_text [get_index (this_line)]

def has_tag (this_line):
   return re.search (r"(tag[0-9]+=)",this_line)

def is_beg_tag (this_line):
   return re.search (r"(^beg_tag[0-9]+$)",this_line)

def is_end_tag (this_line):
   return re.search (r"(^end_tag[0-9]+$)",this_line)

# -------------------------------------------------------------------------
#  stack operations

stack = []
stack_index = 0
max_stack_index = 5
for i in range (0,max_stack_index):   # create an empty stack
   stack.append(0)  # using zero forces any non-tagged output to be stored in tag_output[0]

def read_stack (index):
   return stack [index]

def push_stack (index, stack_index):
   if stack_index < max_stack_index:
      stack_index = stack_index + 1
      stack [stack_index] = index
      return stack_index
   else:
      print ("> Depth of nested mplBeg/mplEnd pairs exceeded, max = "+str(max_stack_index)+", exit\n")
      sys.exit (1)

def pop_stack (index, stack_index):
   if stack_index > 0:
      if index == read_stack (stack_index):
         stack [stack_index] = 0
         return stack_index - 1
      else:
         print ("> Error with mplBeg/mplEnd pairs for tag index: "+str(index)+", exit\n")
         sys.exit (1)
   else:
      print ("> Error with mplBeg/mplEnd pairs, check for missing mplBeg or mplEnd, exit\n")
      sys.exit (1)

def parse (this_line):
   if is_beg_tag (this_line):
      return Type.BegTag
   elif is_end_tag (this_line):
      return Type.EndTag
   else:
      return Type.PlainText

def append_text (this_line, index):
   tag_output[index].append(this_line.rstrip("\n"))

def tex_macro (tex, index):
   the_lines = tag_output [index]
   tex.write ("\mpltag{"+tag_name[index]+"}{%\n")
   for i in range (0,len(the_lines)):
      if not empty_line (the_lines[i]):
         tex.write (the_lines[i]+"%\n")
   tex.write("}\n")

# -----------------------------------------------------------------------------
# the main code

import argparse

parser = argparse.ArgumentParser(description="Post-process Maple output")
parser.add_argument("-i", dest="input", metavar="source", help="LaTeX-Maple source file (without .tex file extension)", required=True)
parser.add_argument("-I", dest="sty", metavar="include", help="Full path to LaTeX-Maple mplmacros.sty file")

the_file_name = parser.parse_args().input
sty_file_name = parser.parse_args().sty

# ----------------------------------------------------------------------------
# include the Maple macos in the .cdbtex file?

if sty_file_name:
    include_macros_header = True
    if not os.path.isfile (sty_file_name):
       print ("> could not find "+sty_file_name)
       print ("> will not include Maple macros")
       include_macros_header = False
else:
    include_macros_header = False

# ----------------------------------------------------------------------------
# file names

idx_file_name = the_file_name + ".mplidx"
tex_file_name = the_file_name + ".mpltex"
src_file_name = the_file_name + ".mpltxt"

# ----------------------------------------------------------------------------
# any tag index/name pairs to read?

if not os.path.isfile (idx_file_name):
   with open(tex_file_name,"w") as tex:
      tex.write ("% no Maple output")
   sys.exit (0)

# ----------------------------------------------------------------------------
# read tag index/name pairs

tag_name   = [""]     # dummy entry at index = 0
tag_done   = [False]  # ditto
tag_found  = [False]  # ditto
tag_output = [[]]     # ditto
num_tag    = 0
tag_index  = 0

with open(idx_file_name, "r") as idx:
   for this_line in idx:
      if has_tag (this_line): # skip any non-tag text (e.g., comments)
         num_tag = num_tag + 1                       # the tag index
         tag_name.append (get_text (this_line))      # the tag name
         tag_done.append (False)
         tag_found.append (False)
         tag_output.append ([])

# note: num_tag = number of tags declared in the Maple/LaTeX source
#       these tags are stored in locations 1,2,3 ... num_tag in the various arrays
#       tag_output[0] will contain all non-tagged Maple output.

# ----------------------------------------------------------------------------
# read Maple output and create LaTeX macros for each tag

if num_tag == 0:
   with open(tex_file_name,"w") as tex:
      tex.write ("% no Maple output")
else:

   if not os.path.isfile (src_file_name):
      with open(tex_file_name,"w") as tex:
         tex.write ("% no Maple output")
      print ("> post-process: Source file " + src_file_name + " not found, exit.")
      print ("> possible error during execution of Maple.")
      sys.exit (1)

   # -------------------------------------------------------------------------
   # read Maple output

   with open(src_file_name,"r") as src:
      for this_line in src:

         line_type = parse (this_line)
         if line_type == Type.BegTag:

            tag_index = get_index (this_line)
            tag_done   [tag_index] = False
            tag_found  [tag_index] = True
            stack_index = push_stack (tag_index,stack_index)

         elif line_type == Type.EndTag:

            tag_index = get_index (this_line)
            tag_done   [tag_index] = True
            tag_found  [tag_index] = True
            stack_index = pop_stack  (tag_index,stack_index)
            tag_index = read_stack (stack_index)

         elif line_type == Type.PlainText:

            append_text (this_line,tag_index)

         else:
            pass # should never get here

   # -----------------------------------------------------------------------
   # create the latex macros, one for each tag

   with open(tex_file_name,"w") as tex:

      if include_macros_header:
         tex.write(r'% ====================================================================='+'\n')
         tex.write(r'% Define Maple macros so that this file may be used by other LaTeX sources.'+'\n')
         tex.write(r'% To include this file in some other LaTeX be sure to add the following line'+'\n')
         tex.write(r'% in the LaTeX preamble.'+'\n')
         tex.write(r'% \input{foo.mpltex}% change foo to match the name of this file.'+'\n')
         tex.write(r'% ---------------------------------------------------------------------'+'\n')
         tex.write(r'\makeatletter'+'\n')
         with open(sty_file_name,"r") as sty:
            for this_line in sty:
               tex.write (this_line)
         tex.write(r'\makeatother'+'\n')

      for i in range (1,num_tag+1):

         tex_macro (tex, i)

   # -------------------------------------------------------------------------
   # report tags that didn't have matching Maple output

   for i in range (1,num_tag+1):
      if not tag_found [i]:
         print ("> post-process: Failed to find output for tag: "+tag_name[i])

   # -------------------------------------------------------------------------
   # report problems with un-matched beg/end pairs

   for i in range (1,num_tag+1):
      if not tag_done [i]:
         print ("> post-process: Something is missing for tag: "+tag_name[i])