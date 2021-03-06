#!/bin/bash

if [ -f ./setupenv.sh ] ; then
  . ./setupenv.sh
fi

mkdir logs
dir=${1%/}
export RUNPIPELINE_LOG_PREFIX=lemmatizer-fr-nolists-$dir
export GATEPLUGIN_LEMMATIZER_NOLISTS=true
runPipeline.sh -Xmx5G  -r EvaluateLemmatizerFR.xgapp "$@" 
