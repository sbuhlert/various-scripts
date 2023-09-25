#!/bin/bash

echo "Target Directory?"
read TargetDirectory

read -p "Ordner auflösen und leere Verzeichnisse dann löschen in $TargetDirectory (j/n)?" -n 1 -r
echo 	#
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
	find $TargetDirectory/ -mindepth 2 -type f -exec mv '{}' $TargetDirectory/ ';'
	find $TargetDirectory -empty -type d -delete
else 
	exit 1
fi

read -p "In Order nach Dateitypen sortieren (j/n)?" -n 1 -r
echo 	#
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
	mkdir $TargetDirectory/PDFs
	mv $TargetDirectory/*.pdf PDFs
	mv $TargetDirectory/*.PDF PDFs 
	mkdir $TargetDirectory/DOCs
	mv $TargetDirectory/*.doc DOCs
	mv $TargetDirectory/*.docx DOCs
	mv $TargetDirectory/*.DOC DOCs
	mv $TargetDirectory/*.DOCX DOCs
	mkdir $TargetDirectory/TeXs
	mv $TargetDirectory/*.tex TeXs
	mkdir $TargetDirectory/MELLs
	mv $TargetDirectory/*.mellel MELLs
	mkdir $TargetDirectory/XLSs
	mv $TargetDirectory/*.xls XLSs
	mv $TargetDirectory/*.xlsx XLSs
	mkdir $TargetDirectory/RTFs
	mv $TargetDirectory/*.rtf RTFs
	mv $TargetDirectory/*.txt RTFs
	mkdir $TargetDirectory/ZIPs
	mv $TargetDirectory/*.zip ZIPs
	mkdir $TargetDirectory/MISC
	mv $TargetDirectory/*.* MISC
else
	exit 1
fi

read -p "TIFFs, JPEGs und PLISTs löschen (j/n)?" -n 1 -r
echo	#
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
	rm $TargetDirectory/*.tiff
	rm $TargetDirectory/*.tif
	rm $TargetDirectory/*.TIFF
	rm $TargetDirectory/*.TIF
	rm $TargetDirectory/*.jpg
	rm $TargetDirectory/*.JPG
	rm $TargetDirectory/*.jpeg
	rm $TargetDirectory/*.JPEG
	rm $TargetDirectory/*.plist
else
	exit 1
fi

# echo "Ordner auflösen und leere Verzeichnisse dann löschen in " + $TargetDirectory + "? (any key / ctrl-c)?" 
# read AnyKey
# find $TargetDirectory/ -mindepth 2 -type f -exec mv '{}' $TargetDirectory/ ';'
# find $TargetDirectory -empty -type d -delete

# echo "In Order nach Dateitypen sortieren (any key / ctrl-c)?"
# read AnyKey
# mkdir $PWD/PDFs
# mv $PWD/*.pdf PDFs
# mv $PWD/*.PDF PDFs
# mkdir $PWD/DOCs
# mv $PWD/*.doc DOCs
# mv $PWD/*.docx DOCs
# mv $PWD/*.DOC DOCs
# mv $PWD/*.DOCX DOCs
# mkdir $PWD/TeXs
# mv $PWD/*.tex TeXs
# mkdir $PWD/MELLs
# mv $PWD/*.mellel MELLs
# mkdir $PWD/XLSs
# mv $PWD/*.xls XLSs
# mv $PWD/*.xlsx XLSs
# mkdir $PWD/RTFs
# mv $PWD/*.rtf RTFs
# mkdir $PWD/ZIPs
# mv $PWD/*.zip ZIPs
