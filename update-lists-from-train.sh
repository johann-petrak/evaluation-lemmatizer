#!/bin/bash

## simple script to update the lists from the mismatches we found and logged 
## when evaluating the training sets for every language (universal dependencies corpora only).
## This uses a simplistic approach where we try to add the most frequent mappings last 
## and simply append single wordform->lemma mappings to the word list files.
## This is done separately for each target POS tag.
## TODO: we could actually do it for response POS tag instead or in addition!!

## NOTE: if a second parameter is given, this is the maximum number of most frequent errors to take
## for updating the list

## we expect the plugin to be in ./gateplugin-dict-lemmatizer and 
## expect parameter 1 to be a directory that contains the log files for all languages
## or assume "./logs" if missing.

indir=logs
if [ "x$1" != "x" ]
then
  indir="$1"
fi

N=500
if [ "x$2" != "x" ]
then
  N="$2"
fi

echo Running for logs directory $indir

declare -a postags=("DET" "VERB" "ADJ" "ADP" "ADV" "NOUN" "PART" "PRON")
# declare -a postags=("DET" "VERB" "ADJ" "ADV" "NOUN" "PART" "PRON")
for lang in en de fr es 
do
  echo Processing for language $lang
  files=`find $indir -name "lemmatizer-$lang-UD_*_train*-log.txt"`
  echo Have log files ${files}
  ## only if we actually found some files ...
  if [ "x${files}" != "x" ]
  then
    ## now for each pos tag we have a list for, do ...
    for pos in "${postags[@]}"
    do
      echo Running for postag $pos
      ## concatenate all the files and grep out the mappings for that postag
      ## At some point in this pipe several 16bit Unicode Byte Markers are created which then mess up the content and 
      ## the sorting, so we use a perl step to remove them:
      ## NOTE!!! This is machine specific and on other machines, it may work without -CSD or may need to search for 
      ## \x{fffe} instead!!!!
      cat $files | grep DEBUG | grep -v "DEBUG:" | grep -P "\\t$pos/" |  tr '/' '\t' | cut -f 6,8 | sed -e 's/.*/\L&/' | perl -p -CSD -e 's/\x{feff}//' |  sort | uniq -c | sed -e 's/^ \+//' | tr ' ' '\t' | sort -k1nr,1nr | head -n $N | sort -k3,3 -k1n,1n | cut -f 2,3 | sed -e 's/\t/===/' -e 's/$/;/' | gzip  > tmp_${lang}_${pos}.txt.gz
      ## now append this to the proper file in the plugin and save it back
      zcat gateplugin-dict-lemmatizer/resources/dictionaries/$lang/${pos}-Dict.txt.gz tmp_${lang}_${pos}.txt.gz | gzip > new_${lang}_${pos}.txt.gz
      if [ "$pos" != "ADP" ] 
      then
        mv new_${lang}_${pos}.txt.gz gateplugin-dict-lemmatizer/resources/dictionaries/$lang/${pos}-Dict.txt.gz
      fi
      ## rm tmp_${lang}_${pos}.txt.gz 
    done
  fi
done
