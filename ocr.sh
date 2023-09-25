#!/bin/zsh

find . -name '*.pdf' | parallel --tag -j 4 ocrmypdf --skip-text -l eng+deu '{}' '{}'
x2