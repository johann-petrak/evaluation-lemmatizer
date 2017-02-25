#!/bin/bash

mkdir logs
rm logs/*
dir=${1%/}
export RUNPIPELINE_LOG_PREFIX=treetagger-en-$dir
runPipeline.sh  -r EvaluateTreetaggerEN.xgapp "$@"
