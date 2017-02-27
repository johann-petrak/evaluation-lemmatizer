#!/bin/bash

if [ -f ./setupenv.sh ] ; then
  . ./setupenv.sh
fi

mkdir logs
dir=${1%/}
export RUNPIPELINE_LOG_PREFIX=treetagger-de-$dir
runPipeline.sh  -r EvaluateTreetaggerDE.xgapp "$@"
