#!/bin/bash

if [ -f ./setupenv.sh ] ; then
  . ./setupenv.sh
fi

mkdir logs
dir=${1%/}
export RUNPIPELINE_LOG_PREFIX=lemmatizer-es-$dir
runPipeline.sh -Xmx5G  -r EvaluateLemmatizerES.xgapp "$@" 
