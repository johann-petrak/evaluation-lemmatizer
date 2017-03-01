#!/bin/bash

## This assumes that language-specific directories with the files from the UP corpus for
## that language as well as output directories with the same name and suffix "_gate" are
## present or linked inside this directory.

# list of input directories to process
inDirs="UD_English_gate UD_French_gate UD_German_gate UD_Spanish_gate UD_Spanish-AnCora_gate"
splits="test train dev"

rm convertAll.log
for indir in $inDirs
do
  for split in $splits
  do
    outdir=${indir}_${split}
    mkdir ${outdir}
    rm ${outdir}/*
    echo Creating and filling directory $outdir
    cp ${indir}/*-${split}.* ${outdir}
  done
done
