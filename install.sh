#!/bin/bash

D4D_URL=https://raw.githubusercontent.com/talos/docker4data/master/cli/d4d
INSTALL_PATH=~/.d4d
PROFILE_PATH=~/.bash_profile

mkdir -p $INSTALL_PATH && curl -s $D4D_URL > $INSTALL_PATH/d4d && chmod a+x $INSTALL_PATH/d4d && echo '

# Adds Docker4Data to PATH
PATH='$INSTALL_PATH':$PATH' >> $PROFILE_PATH
source $PROFILE_PATH

echo "
Installed d4d at $INSTALL_PATH and added to PATH via $PROFILE_PATH.

You can get started with

   d4d -h
"
