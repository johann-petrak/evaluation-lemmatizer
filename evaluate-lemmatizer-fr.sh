#!/bin/bash

mkdir logs
# rm logs/*
runPipeline.sh -Xmx5G  -r EvaluateLemmatizerFR.xgapp "$@" 
