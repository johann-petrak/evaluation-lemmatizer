#!/bin/bash

mkdir logs
rm logs/*
runPipeline.sh  -r EvaluateTreetaggerES.xgapp "$@"
