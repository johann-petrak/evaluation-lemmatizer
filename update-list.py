#!/usr/bin/env python
from __future__ import print_function
import sys
import re
import argparse

parser = argparse.ArgumentParser(description="Read a merged list from stdin, clean it and write to stdout")
parser.add_argument("-v", action='store_true', help="Show more messages about what the program is doing.")
args = parser.parse_args()

## 1) read the list file into memory and store all maps from a form to a lemma in a dictionary
linenr=0
duplicates=0
dupsame=0
dupdiff=0
lemmaof = {}
for line in sys.stdin:
    linenr += 1
    line = line.rstrip("\n")
    if "===" not in line:
      print("ERROR: odd line without a === at line",linenr," - ignored",file=sys.stderr)
      continue
    lemma, forms = line.split("===")
    forms = [form for form in forms.split(";") if form != ""]
    for form in forms:
      if form in lemmaof:
        duplicates += 1
        if lemmaof[form] == lemma:
          dupsame += 1
        else:
          dupdiff += 1
      lemmaof[form] = lemma
      ##print("DEBUG: lemma of",form,"is",lemma,file=sys.stderr)
      
## TODO: we could now compress this by grouping all the forms together
## for each lemm, for now we skip this
for word,lemma in lemmaof.items():
  print(lemma,"===",word,";",sep="")

        
      
    
