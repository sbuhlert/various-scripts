# ad .doc as suffix

for file in *; do mv "$file" "$(basename "$file").doc"; done;
