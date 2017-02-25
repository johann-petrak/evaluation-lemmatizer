#!/bin/bash

mkdir logs
rm logs/*
dir=${1%/}
export RUNPIPELINE_LOG_PREFIX=lemmatizer-en-$dir
runPipeline.sh -Xmx5G -r EvaluateLemmatizerEN.xgapp "$@"
