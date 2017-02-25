#!/bin/bash

mkdir logs
# rm logs/*
dir=${1%/}
export RUNPIPELINE_LOG_PREFIX=lemmatizer-es-$dir
runPipeline.sh -Xmx5G  -r EvaluateLemmatizerES.xgapp "$@" 