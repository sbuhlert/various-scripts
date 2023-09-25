find . -name "*.docx" | while read i; do pandoc -f docx -t markdown "$i" -o "${i%.*}.md"; done
