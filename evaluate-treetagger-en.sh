#!/bin/bash

mkdir logs
rm logs/*
runPipeline.sh  -r EvaluateTreetaggerEN.xgapp "$@"
