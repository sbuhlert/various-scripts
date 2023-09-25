#!/bin/bash
export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:/opt/homebrew/bin:$(which ocrmypdf)

dir=/Users/steffenbuhlert/Desktop/OCR_output/

for f in "$@"
do
	ocrmypdf -l deu+eng --skip-text "$f" "$f"
	mv "$f" "$dir"
done
