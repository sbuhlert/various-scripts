#!/bin/zsh

# create folder with YYYYMMDD naming convention
d="$(date +"%Y%m%d")"
mkdir "$PWD/$d"

# define watched folder and new folder to operate in
TargetDirectory="$PWD/$d"
WorkingDirectory="$PWD"

# confirm and sort in subfolders
read -p "In Order nach Dateitypen sortieren (j/n)?" -n 1 -r
echo 	#
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
	mkdir $TargetDirectory/PDFs
	mv $WorkingDirectory/*.pdf $TargetDirectory/PDFs
	mv $WorkingDirectory/*.PDF $TargetDirectory/PDFs 
	mkdir $TargetDirectory/DOCs
	mv $WorkingDirectory/*.doc $TargetDirectory/DOCs
	mv $WorkingDirectory/*.docx $TargetDirectory/DOCs
	mv $WorkingDirectory/*.DOC $TargetDirectory/DOCs
	mv $WorkingDirectory/*.DOCX $TargetDirectory/DOCs
	mkdir $TargetDirectory/TeXs
	mv $WorkingDirectory/*.tex $TargetDirectory/TeXs
	mkdir $TargetDirectory/MELLs
	mv $WorkingDirectory/*.mellel $TargetDirectory/MELLs
	mkdir $TargetDirectory/XLSs
	mv $WorkingDirectory/*.xls $TargetDirectory/XLSs
	mv $WorkingDirectory/*.xlsx $TargetDirectory/XLSs
	mkdir $TargetDirectory/RTFs
	mv $WorkingDirectory/*.rtf $TargetDirectory/RTFs
	mv $WorkingDirectory/*.txt $TargetDirectory/RTFs
	mkdir $TargetDirectory/ZIPs
	mv $WorkingDirectory/*.zip $TargetDirectory/ZIPs
	mkdir $TargetDirectory/Slides
	mv $WorkingDirectory/*.ppt $TargetDirectory/Slides
	mv $WorkingDirectory/*.PPT $TargetDirectory/Slides
	mv $WorkingDirectory/*.PPTX $TargetDirectory/Slides
	mv $WorkingDirectory/*.pptx $TargetDirectory/Slides
	mv $WorkingDirectory/*.key $TargetDirectory/PPTs
	mkdir $TargetDirectory/MISC
	mv $WorkingDirectory/*.* $TargetDirectory/MISC
else
	exit 1
fi

echo "Sorting done."

# run OCR on PDFs in PDF subfolder
echo "Now performing OCR on PDFs in PDF subfolder…"

cd $TargetDirectory/PDFs
find . -name '*.pdf' | parallel --tag -j 2 -l eng+deu --skip-text ocrmypdf '{}' '{}'