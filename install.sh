#!/bin/bash

# fetch and compile the submodules
git submodule init
git submodule update
git submodule foreach ant

# manually install TreeTagger 3.2.1
echo Please install TreeTagger version 3.2.1 into the directory treetagger-3.2.1
echo The following is needed
echo - tagger package for LINUX
echo - tagging scripts
echo - installation script
echo '- parameter files for languages: EN, DE, FR, SP (UTF8 versions)'
