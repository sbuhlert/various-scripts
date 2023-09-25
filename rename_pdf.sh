#!/bin/zsh

for f in *.PDF; do pre="${f%.PDF}"; echo mv -- "$f" "${pre}.pdf"; done

#  find . -iname "*.PDF" | fgrep -v .pdf | xargs -n1 echo rename .PDF .pdf
