#!/bin/bash

mkdir logs
rm logs/*
runPipeline.sh  -r EvaluateTreetaggerDE.xgapp de-tiger
