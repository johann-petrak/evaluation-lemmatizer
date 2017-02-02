#!/bin/sh

PRG="$0"
CURDIR="`pwd`"
# need this for relative symlinks
while [ -h "$PRG" ] ; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`"/$link"
  fi
done
SCRIPTDIR=`dirname "$PRG"`
SCRIPTDIR=`cd "$SCRIPTDIR"; pwd -P`

TREETAGGER_HOME=$SCRIPTDIR/treetagger-3.2.1
BIN=${TREETAGGER_HOME}/bin
CMD=${TREETAGGER_HOME}/cmd
LIB=${TREETAGGER_HOME}/lib

TAGGER=${BIN}/tree-tagger
ABBR_LIST=${LIB}/english-abbreviations
PARFILE=${LIB}/english-utf8.par
##FILTER=${CMD}/filter-german-tags

cat $* |
# tagging
$TAGGER $PARFILE -token -lemma -sgml 
# error correction
## $FILTER

