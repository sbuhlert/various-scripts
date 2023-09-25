#! /bin/bash

if [[ ! "$#" = "1" ]]
  then
      echo "Usage: $0 /path/to/PDFDirectory"
      exit 1
fi

PDFDIRECTORY="$1"

while IFS= read -r -d $'\0' FILE; do
    PDFFONTS_OUT="$(pdffonts "$FILE" 2>/dev/null)"
    RET_PDFFONTS="$?"
    FONTS="$(( $(echo "$PDFFONTS_OUT" | wc -l) - 2 ))"
    if [[ ! "$RET_PDFFONTS" = "0" ]]
      then
          READ_ERROR=1
          echo "Error while reading $FILE. Skipping..."
          continue
    fi
    if [[ "$FONTS" = "0" ]]
      then
          echo "NOT SEARCHABLE: $FILE"
      else
          echo "SEARCHABLE: $FILE"
    fi
done < <(find "$PDFDIRECTORY" -type f -name '*.pdf' -print0)

echo "Done."
if [[ "$READ_ERROR" = "1" ]]
  then
      echo "There were some errors."
fi
