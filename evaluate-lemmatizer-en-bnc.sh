#!/bin/bash

mkdir logs
rm logs/*
runPipeline.sh  -r EvaluateLemmatizerEN.xgapp BNC
