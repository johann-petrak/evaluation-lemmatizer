#!/bin/bash

## simple script to show the list of 10 most frequent errors for all languages and categories,
## based on the output log files in a directory.
## First argument, if given: directory of log files, default is ./logs
## Second argument, if given as well: language code
## Third argument, if given as well: POS tag

N=10

indir=logs
if [ "x$1" != "x" ]
then
  indir="$1"
fi

declare -a langs=(de en es fr)
if [ "x$2" != "x" ]
then
  declare -a langs=("$2")
fi

declare -a postags=("DET" "VERB" "ADJ" "ADP" "ADV" "NOUN" "PART" "PRON")

if [ "x$3" != "x" ]
then
  declare -a postags=("$3")
fi

for lang in "${langs[@]}"
do
  echo Processing for language $lang
  files=`find $indir -name "lemmatizer-$lang-UD_*-log.txt"`
  echo Have log files ${files}
  ## only if we actually found some files ...
  if [ "x${files}" != "x" ]
  then
    ## now for each pos tag we have a list for, do ...
    for pos in "${postags[@]}"
    do
      echo =============================================================
      echo Language $lang POS $pos
      ## concatenate all the files and grep out the mappings for that postag
      ## At some point in this pipe several 16bit Unicode Byte Markers are created which then mess up the content and 
      ## the sorting, so we use a perl step to remove them:
      ## NOTE!!! This is machine specific and on other machines, it may work without -CSD or may need to search for 
      ## \x{fffe} instead!!!!
      cat $files | grep DEBUG | grep -v "DEBUG:" | grep -P "\\t$pos/" |  tr '/' '\t' | cut -f 6,8 | sed -e 's/.*/\L&/' | perl -p -CSD -e 's/\x{feff}//' |  sort | uniq -c | sed -e 's/^ \+//' | tr ' ' '\t' | sort -k1nr,1nr  | head -n $N
    done
  fi
done
