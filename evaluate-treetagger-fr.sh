#!/bin/bash

mkdir logs
rm logs/*
runPipeline.sh  -r EvaluateTreetaggerFR.xgapp "$@"
