#!/bin/bash

mkdir logs
rm logs/*
dir=${1%/}
export RUNPIPELINE_LOG_PREFIX=treetagger-fr-$dir
runPipeline.sh  -r EvaluateTreetaggerFR.xgapp "$@"
