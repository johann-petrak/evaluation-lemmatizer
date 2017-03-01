# Evaluate Lemmatizer PR

This contains the tools and pipelines to evaluate the GATE plugin 
gateplugin-dict-lemmatizer (https://github.com/GateNLP/gateplugin-dict-lemmatizer).

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

Before running the evaluation the directories for each corpus (already converted to GATE documents) must be copied or linked into the 
current directory with these names:
* British National Corpus: ./bnc-corpus-gate
* German Tiger Corpus: ./tiger-gate
* English Universal Dependencies Corpus: `./UD_English_gate`
* German Universal Dependencies Corpus: `./UD_German_gate`
* French Universal Dependencies Corpus: `./UD_French_gate`
* Spanish Universal Dependencies Corpus: `./UD_Spanish_gate`
* Spanish Universal Dependencies Ancora Corpus: `./UD_Spanish-Ancora_gate`

The evaluations on the corpora from the Universal dependencies project are done 
separately for the training and test sets, to create directories for each part
from the directory containing all files run the script `./splitAll.sh`. This will
create additional directories with a name suffix that indicates the part e.g.
`UD_French_gate_train`. 

## Running the evaluations


Just run the script for the evaluation of a language using either the lemmatizer plugin or treetagger and 
specify the corpus directory to evaluate on, e.g. 
`./evaluate-lemmatizer-en.sh bnc-corpus-gate` to
evaluate the lemmatizer PR on the English British National corpus or
`./evaluate-treetager-de.sh UD_German_gate_train` to evaluate the treetagger
on the training set of the German Universal dependencies corpus.

For each evaluation, a detailed log that also includes the accuracy for the run and 
a file containing timing information is created in the `./logs` directory.

## License

GPL 3.0 see file LICENSE.txt
