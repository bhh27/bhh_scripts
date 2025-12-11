#!/bin/bash

BHH_SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BHH_ROOT="$HOME/.local/share/bhh"
BINARIES="$BHH_ROOT/bin"
BASHRC="$HOME/.bashrc"
PATH_EXPORT='export PATH="$PATH:'$BINARIES'"'

#Check bhh folder exists, if not create it and parent structure
if ! [[ -d "$BHH_ROOT" ]]; then
#    echo "Folder already exists: $BHH_ROOT"
#else
    echo "Folder does not exist, creating it..."
    mkdir -p "$BHH_ROOT"
    echo "Folder created: $BHH_ROOT"
fi

#copy binaries folder
echo "Copying binaries to: $BINARIES"
cp -r $BHH_SETUP_DIR/bin $BHH_ROOT

#check binaries folder exists in $PATH, if not export
if [[ ":$PATH:" != *":$BINARIES:"* ]]; then
    echo "Adding $BINARIES to PATH"
    #export PATH="$PATH:$BINARIES"
    
    touch "$BASHRC"

    if ! grep -Fxq "$PATH_EXPORT" "$BASHRC"; then
        echo "$PATH_EXPORT" >> "$BASHRC"
    fi

    source $BASHRC
fi


#ensure all binaries are excuteable
if [[ -d "$BINARIES" ]]; then
    chmod +x "$BINARIES"/*
fi
