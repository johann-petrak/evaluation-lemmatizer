#!/bin/bash

if [ -f ./setupenv.sh ] ; then
  . ./setupenv.sh
fi

mkdir logs
dir=${1%/}
export RUNPIPELINE_LOG_PREFIX=lemmatizer-de-nohfst-$dir
export GATEPLUGIN_LEMMATIZER_NOHFST=true
runPipeline.sh -Xmx5G -r EvaluateLemmatizerDE.xgapp "$@" 
