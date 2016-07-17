#!/bin/bash
# ----- Just steggin' bro. -----
# version 0.0.2
# system_page - A script to accept two files, concatenate them, or deconcatonate a concatenated file.

if [ $# = 0 ]; then
	echo "Error: We can't be steggin' without any files."
	exit 1
fi

# Function Definitions
function declareInitVars {
	LAST_BYTE="$( wc -c $1 | awk '{print $1}')"
	START_BYTE=$(($LAST_BYTE + 1))
	STEG_FILE=justStegginBro-$1
}

function preventMultiSteggin {
	CHECK="$(tail -c 500 $1 | grep -a 'SECSHA' | awk '{print $1}')"
	if [ "$CHECK" = "SECSHA:" ]; then
		echo "Error: Carrier file has been previously stegged. Exiting without steggin"
		exit 1
	fi
}

function concatenate {
	echo concatenating $1 and $2
	cat $1 $2 > $STEG_FILE
}

function declareStegVars {
	END_BYTE="$(wc -c $STEG_FILE | awk '{print $1}')"
	META_BYTE=$(($END_BYTE + 1))
}

function getShaHashes {
	CAR_SHA="$(shasum -a 256 $1 | awk '{print $1}')"
	SECRET_SHA="$(shasum -a 256 $2 | awk '{print $1}')"
}

function makeMetaDataText {
	echo "CARSHA: $CAR_SHA" > metaData.txt
	echo "SECSHA: $SECRET_SHA" >> metaData.txt
	echo "STARTBYTE: $START_BYTE" >> metaData.txt
	echo "ENDBYTE: $END_BYTE" >> metaData.txt
	echo "METABYTE: $META_BYTE" >> metaData.txt
	cat metaData.txt >> $STEG_FILE
}

function echoSucess {
	echo Meta File:
	cat metadata.txt
	echo ""
	echo ""
	echo !!!!! Sucess $2 is hidden in the file $STEG_FILE !!!!!
}

function cleanup {
	rm metadata.txt
}

function readMetaDataText {
	CHECK="$(tail -c 500 $1 | grep -a 'SECSHA' | awk '{print $1}')"
	if [ "$CHECK" != "SECSHA:" ]; then
		echo "Error: File has not been previously stegged."
		exit 1
	fi
	SECSHA="$(tail -c 500 $1 | grep -a 'SECSHA' | awk '{print $2}')"
	CARSHA="$(tail -c 500 $1 | grep -a 'CARSHA' | awk '{print $2}')"
	STARTBYTE="$(tail -c 500 $1 | grep -a 'STARTBYTE' | awk '{print $2}')"
	ENDBYTE="$(tail -c 500 $1 | grep -a 'ENDBYTE' | awk '{print $2}')"
	METABYTE="$(tail -c 500 $1 | grep -a 'METABYTE' | awk '{print $2}')"
}

function extractSecretFile {
	head -c $ENDBYTE $1 | tail -c +$STARTBYTE > extractedFile
	EXTRACTEDSHA="$(shasum -a 256 ./extractedFile | awk '{print $1}')"
	echo ExtractedSha: $EXTRACTEDSHA
	echo Original Sha: $SECSHA
	if [ "$EXTRACTEDSHA" = "$SECSHA" ]; then
		echo "SUCCESS: EXTRACTED FILE IS IDENTICAL TO ORIGINALLY STEGGED FILE. File saved in ./extractedFile"
	else
		echo "WARNING: EXTRACTED STEG FILE HAS BEEN TAMPERED WITH SINCE ORIGINALLY STEGGED"
	fi
}

# Main Code
if [ $# = 2 ]; then
	declareInitVars $1
	preventMultiSteggin $1
	concatenate $1 $2
	declareStegVars
	getShaHashes $1 $2
	makeMetaDataText
	echoSucess
	cleanup
fi

# Split a file that hass been previously stegged.
if [ $# = 1 ]; then
	readMetaDataText $1
	extractSecretFile $1
fi

exit 0
