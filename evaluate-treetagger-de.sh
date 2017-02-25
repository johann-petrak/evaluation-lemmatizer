#!/bin/bash

mkdir logs
rm logs/*
dir=${1%/}
export RUNPIPELINE_LOG_PREFIX=treetagger-de-$dir
runPipeline.sh  -r EvaluateTreetaggerDE.xgapp de-tiger
