#!/bin/bash


# ---- Just steggin' bro. ----
# version 0.0.2
# system_page - A script to accept two files, concatenate them, or deconcatonate a concatenated file.

if [ $# = 0 ]
then
	echo "Error: We can't be steggin' without any files."
	exit 1
fi


# Config vars examples

LAST_BYTE="$( wc -c $1 | awk '{print $1}')"
START_BYTE=$(($LAST_BYTE + 1))
STEG_FILE=justStegginBro-$1


# Function Definitions

function checkForSteggin {
	CHECK="$(tail -c 500 $1 | grep -a 'SECSHA' | awk '{print $1}')"
	if [ "$CHECK" = "SECSHA:" ];
	then
		echo "Error: Carrier file has been previously stegged. Exiting without steggin"
		exit 1
	fi
}

function concatenate {
	echo concatenating $1 and $2
	cat $1 $2 > $STEG_FILE
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

function readMetaDataText {
	SECSHA="$(tail -c 500 $1 | grep -a 'SECSHA' | awk '{print $2}')"
	CARSHA="$(tail -c 500 $1 | grep -a 'CARSHA' | awk '{print $2}')"
	STARTBYTE="$(tail -c 500 $1 | grep -a 'STARTBYTE' | awk '{print $2}')"
	ENDBYTE="$(tail -c 500 $1 | grep -a 'ENDBYTE' | awk '{print $2}')"
	METABYTE="$(tail -c 500 $1 | grep -a 'METABYTE' | awk '{print $2}')"
}

function extractSecretFile {
	echo STARTBYTE: $STARTBYTE
	echo ENDBYTE: $ENDBYTE
	head -c $ENDBYTE $1 | tail -c +$STARTBYTE > extractedFile
	EXTRACTEDSHA="$(shasum -a 256 ./extractedFile | awk '{print $1}')"
	echo ExtractedSha: $EXTRACTEDSHA
	echo Original Sha: $SECSHA
	if [ "$EXTRACTEDSHA" = "$SECSHA" ];
	then
		echo "SUCCESS: EXTRACTED FILE IS IDENTICAL TO ORIGINALLY STEGGED FILE"
		echo "File saved in ./extractedFile"
	else
		echo "File saved in ./extractedFile"
		echo "WARNING: EXTRACTED STEG FILE HAS BEEN TAMPERED WITH SINCE ORIGINALLY STEGGED"
	fi
}


# Main Code

if [ $# = 2 ]
then
	checkForSteggin $1
	concatenate $1 $2
	getShaHashes $1 $2


	# Declare new variables

	END_BYTE="$(wc -c $STEG_FILE | awk '{print $1}')"
	META_BYTE=$(($END_BYTE + 1))

	# Make meta data file
	makeMetaDataText


	# Success output

	echo Carrier File Size: $LAST_BYTE bytes
	echo Carrier File SHA256: $CAR_SHA
	echo Secret File Start Byte: $START_BYTE
	echo Secret File SHA256: $SECRET_SHA
	echo Secret File End Byte: $END_BYTE
	echo Meta Byte: $META_BYTE
	echo Meta File:
	cat metadata.txt
	echo ""
	echo ""
	echo !!!!! Sucess $2 is hidden in the file $STEG_FILE !!!!!

	#Cleanup

	rm metadata.txt
fi


# Split a file that hass been previously stegged.

if [ $# = 1 ]
then
	readMetaDataText $1
	extractSecretFile $1
fi

exit 0
