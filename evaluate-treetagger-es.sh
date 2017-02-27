#!/bin/bash

if [ -f ./setupenv.sh ] ; then
  . ./setupenv.sh
fi

mkdir logs
dir=${1%/}
export RUNPIPELINE_LOG_PREFIX=treetagger-es-$dir
runPipeline.sh  -r EvaluateTreetaggerES.xgapp "$@"
