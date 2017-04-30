#!/bin/bash

## simple script to list all evaluation results from a logs directory.

## expect parameter 1 to be a directory that contains the log files for all languages
## or assume "./logs" if missing.

## Shows for each corpus a line with the shortened corpus name, the strict accuracy case insensitive
## among all tokens with a target lemma, and the strict accuracy case sensitive for the same

indir=logs
if [ "x$1" != "x" ]
then
  indir="$1"
fi

resultLine1='Recall/Acc(coext/hasTargetLemma'

echo Running for logs directory $indir

echo Corpus AccStrictCaseInsensitive AccStrictCaseSensitive
for lang in en de fr es 
do
  files=`ls $indir/lemmatizer-${lang}*log.txt 2>/dev/null`
  for file in $files
  do
    acc1=`grep "$resultLine1" $file | cut -d: -f2`
    corpus=`echo $file | sed -e 's/.*\/lemmatizer-..-//' -e 's/-[0-9]\+-log.txt\+//' -e 's/_gate_/-/'`
    echo $corpus $acc1
  done
done
