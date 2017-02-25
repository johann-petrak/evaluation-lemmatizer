#!/bin/bash

mkdir logs
rm logs/*
dir=${1%/}
export RUNPIPELINE_LOG_PREFIX=treetagger-es-$dir
runPipeline.sh  -r EvaluateTreetaggerES.xgapp "$@"
