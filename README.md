# Evaluate Lemmatizer PR

This contains the tools and pipelines to evaluate the GATE plugin 
gateplugin-Lemmatizer (https://github.com/GateNLP/gateplugin-Lemmatizer).

## Installation

The following is required to use this directory
* probably only runs under a Linux-like OS
* GATE (version 8.x) must be installed
* Java 8 SDK
* the gatetool-runpipeline tool must be installed and on the path
  (https://github.com/johann-petrak/gatetool-runpipeline)
  and all the dependencies for that tool (see there)
* TreeTagger 3.2.1 must get installed into the directory ./treetagger-3.2.1
  (see http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/)
* Run the script `./install.sh` to fetch and compile the required GATE plugins
* The GATE version of all the corpora for which to carry out the evaluation. The following 
  tools can be used to convert the original corpora to GATE format:
  * corpusconversion-bnc () to convert the British National Corpus to GATE format
  * corpusconversion-tiger () to convert the German Tiger corpus to GATE format
  * corpusconversion-universal-dependencies () to convert the Universal Dependencies Treebanks for
    languages DE, FR, ES to GATE format.

Before running the evaluation the directories for each corpus must be copied or linked into the 
current directory with these names:
* British National Corpus: ./en-bnc
* German Tiger Corpus: ./de-tiger
* French Treebank: ./fr-treebank
* French Universal Dependencies Corpus: ./fr-udep
* Spanish Universal Dependencies Corpus: ./es-udep

## Running the evaluations

Just run the script for the corresponding evaluation, e.g. `./evaluate-lemmatizer-en-bnc.sh` to
evaluate the lemmatizer PR on the English British National corpus.

## License

GPL 3.0 see file LICENSE.txt
