#!/bin/bash

if [ -f ./setupenv.sh ] ; then
  . ./setupenv.sh
fi

mkdir logs
dir=${1%/}
export RUNPIPELINE_LOG_PREFIX=lemmatizer-fr-$dir
runPipeline.sh -Xmx5G  -r EvaluateLemmatizerFR.xgapp "$@" 
