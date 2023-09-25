#!/bin/bash

# define directories

SourceDir="/Users/steffenbuhlert/Desktop/Sortieren"
TargetDir="/Users/steffenbuhlert/Desktop/Sortiert"

echo

# create subfolder to operate in with YYYYMMDD naming convention

d="$(date +"%Y%m%d")"
TargetSubDir="$TargetDir/$d"
mkdir $TargetSubDir

# confirm and sort in subfolders

cd $SourceDir
read -p "In Order nach Dateitypen sortieren (j/n)?" -n 1 -r
echo 	#
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
	 mkdir $TargetSubDir/PDFs
	 mv $SourceDir/*.pdf $TargetSubDir/PDFs/
	 mv $SourceDir/*.PDF $TargetSubDir/PDFs/
	 mkdir $TargetSubDir/DOCs/
	 mv $SourceDir/*.doc $TargetSubDir/DOCs/
	 mv $SourceDir/*.docx $TargetSubDir/DOCs/
	 mv $SourceDir/*.DOC $TargetSubDir/DOCs/
	 mv $SourceDir/*.DOCX $TargetSubDir/DOCs/
	 mv $SourceDir/*.ODT $TargetSubDir/DOCs/
	 mv $SourceDir/*.DOTX $TargetSubDir/DOCs/
	 mv $SourceDir/*.dotx $TargetSubDir/DOCs/
	 mv $SourceDir/*.dot $TargetSubDir/DOCs/
	 mv $SourceDir/*.DOT $TargetSubDir/DOCs/
	 mkdir $TargetSubDir/LaTeX
	 mv $SourceDir/*.tex $TargetSubDir/LaTeX/
	 mkdir $TargetSubDir/MELLEL
	 mv $SourceDir/*.mellel $TargetSubDir/MELLEL/
	 mkdir $TargetSubDir/SHEETS
	 mv $SourceDir/*.xls $TargetSubDir/SHEETS/
	 mv $SourceDir/*.XLS $TargetSubDir/SHEETS/
	 mv $SourceDir/*.XLSX $TargetSubDir/SHEETS/
	 mv $SourceDir/*.xlsx $TargetSubDir/SHEETS/
	 mv $SourceDir/*.numbers $TargetSubDir/SHEETS/
	 mkdir $TargetSubDir/TEXT
	 mv $SourceDir/*.rtf $TargetSubDir/TEXT/
	 mv $SourceDir/*.RTF $TargetSubDir/TEXT/
	 mv $SourceDir/*.txt $TargetSubDir/TEXT/
 	 mv $SourceDir/*.TXT $TargetSubDir/TEXT/
	 mkdir $TargetSubDir/ZIPs
	 mv $SourceDir/*.zip $TargetSubDir/ZIPs/
	 mkdir $TargetSubDir/Slides
	 mv $SourceDir/*.ppt $TargetSubDir/Slides/
	 mv $SourceDir/*.PPT $TargetSubDir/Slides/
	 mv $SourceDir/*.PPTX $TargetSubDir/Slides/
	 mv $SourceDir/*.pptx $TargetSubDir/Slides/
	 mv $SourceDir/*.key $TargetSubDir/PPTs/
	 mkdir $TargetSubDir/MISC
	 mv $SourceDir/*.* $TargetSubDir/MISC/
else
	exit 1
fi

echo "Sortieren erledigt:"

# show results in tree view

tree -L 6 -N $TargetSubDir

# run OCR on PDFs in PDF subfolder

read -p "OCR auf die PDFs durchführen (j/n)?" -n 1 -r
echo #
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
	cd $TargetSubDir/PDFs
	find . -name '*.pdf' | parallel --tag -j 2 ocrmypdf -l eng+deu --skip-text '{}' '{}'	
else
	exit 1
fi

echo "OCR erledigt."
exit