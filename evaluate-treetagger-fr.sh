#!/bin/bash

if [ -f ./setupenv.sh ] ; then
  . ./setupenv.sh
fi

mkdir logs
dir=${1%/}
export RUNPIPELINE_LOG_PREFIX=treetagger-fr-$dir
runPipeline.sh  -r EvaluateTreetaggerFR.xgapp "$@"
