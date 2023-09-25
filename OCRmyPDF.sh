#!/bin/bash
find . -name '*.pdf' | parallel --tag -j 2 ocrmypdf --lang deu+eng --skip-text '{}' '{}'