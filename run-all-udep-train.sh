#!/bin/bash

## simple script to run the lemmatizer evaluation on all dep training 
## corpora so we get the log outputs in ./logs
## only works if logs does not yet exist or is empty!
## Parameter 1 can be used to choose a different log directory.

## expect parameter 1 to be a directory that contains the log files for all languages
## or assume "./logs" if missing.

indir=logs
if [ "x$1" != "x" ]
then
  indir="$1"
fi

langen=English
langes=Spanish
langde=German
langfr=French

echo Running for logs directory $indir

mkdir $indir

files=`find $indir/ -name '*.log.txt'`

if [ "x$files" != "x" ]
then
  echo Directory $indir already contains log files, not messing up
  exit 1
fi

for lang in en de fr es 
do
  tmp=lang$lang
  name=${!tmp}
  echo Processing for language $lang / $name
  files=`ls -d UD_${name}*_train`
  echo Files $files
  for corpus in $files
  do
    echo evaluating on corpus $corpus
    ./evaluate-lemmatizer-${lang}.sh $corpus
  done
done
