#!/bin/bash

mkdir logs
# rm logs/*
runPipeline.sh -Xmx5G  -r EvaluateLemmatizerDE.xgapp "$@" 
