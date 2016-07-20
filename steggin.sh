#!/bin/bash
# ----- Just steggin' bro. -----
# version 0.1.0
# system_page - A script to accept two files, concatenate them, or deconcatonate a concatenated file.

if [ "$#" = 0 ]; then
	echo "Error: We can't be steggin' without any files. Use -h or --help." >&2
	exit 1
fi

# Function Definitions
function exitFunction {
	echo "Error - Bad Command: $1 not found. Use -h or --help." >&2
	exit 1
}

function helpFunction {
	echo "Usage: $0 [options...]"; echo
	echo "   -h| --help                 Show help."; echo
	echo "   -c| --carrier=             Carrier file to be used to hide a file. Must be used with -e and -o."; echo
	echo "   -s| --secret=              Secret file to be used hidden in the carrier file. Must be used with -c and -o."; echo
	echo "   -e| --extract=             Stegged file from which to extract a message. Must be used with -o."; echo
	echo "   -o| --output=              Output file in which to create a stegged file. Must be used with -c and -s."
	echo "                              or"
	echo "                              Output file in which to extract a hidden file. Must be used with -e."; echo
	exit 1
}

# while loop to parse arguments
while [ "$#" -gt 0 ]; do
	case "$1" in
		--help) helpFunction; shift 1;;
		-h) helpFunction; shift 1;;
		--carrier=*) [[ -s "${1#*=}" ]] && carrier="${1#*=}" || exitFunction "$1"; shift 1;;
		--secret=*) [[ -s "${1#*=}" ]] && secret="${1#*=}" || exitFunction "$1"; shift 1;;
		--extract=*) [[ -s "${1#*=}" ]] && stegfile="${1#*=}" || exitFunction "$1"; shift 1;;
		--output=*) [[ "${1#*=}" ]] && output="${1#*=}" || exitFunction "$1"; shift 1;;
		--carrier|--secret|--extract|--output) echo "$1 must be set = to a filename. Ex. $1=yourFile.ext. Use -h or --help" >&2; exit 1;;
		-c) [[ -s "$2" ]] && carrier="$2" || exitFunction "$1 $2"; shift 2;;
		-s) [[ -s "$2" ]] && secret="$2" || exitFunction "$1 $2"; shift 2;;
		-e) [[ -s "$2" ]] && stegfile="$2" || exitFunction "$1 $2"; shift 2;;
		-o) [[ "$2" ]] && output="$2" || exitFunction "$1"; shift 2;;
		-*) exitFunction "$1"; shift 1;;
		*) exitFunction "$1"; shift 1;;
	esac
done

function errorCases {
	if [[ -n "$stegfile" && -z "$output" ]]; then
		echo "Error - Bad Command: Specifying -e|--extract= requires an -o|--output= file. Use -h or --help." >&2
		exit 1
	fi
	if [[ -n "$output" && -z "$carrier" && -z "$stegfile" ]]; then
		echo "Error - Bad Command: Specifying -o|--output= requires either -c|--carrier= and a -s|--secret= files or an -e|--extract= file. Use -h or --help" >&2
		exit 1
	fi
	if [[ -n "$carrier" && -n "$stegfile" ]]; then
		echo "Error - Bad Command: You cannot specify both a -c|--carrier= file and an -e|--extract= file. Use -h or --help." >&2
		exit 1
	fi
	if [[ -n "$secret" && -n "$stegfile" ]]; then
		echo "Error - Bad Command: You cannot specify both a -s|--secret= file and an -e|--extract= file. Use -h or --help." >&2
		exit 1
	fi
	if [[ -s "$output" ]]; then
		echo "Error - Bad Command: A file already exists with that name. Exiting without steggin'." >&2
		echo "                     Please rename the existing file, or specify a different -o output file name. Use -h or --help." >&2
		exit 1
	fi
}

function declareInitialVariables {
	lastByte="$( wc -c $carrier | awk '{print $1}')"
	startByte=$(($lastByte + 1))
}

function preventMultipleSteggin {
	validStegFileCheck="$(tail -c 500 $carrier | grep -a 'SECSHA' | awk '{print $1}')"
	if [ "$validStegFileCheck" = "SECSHA:" ]; then
		echo "Error: Carrier file $carrier has been previously stegged. Exiting without steggin'." >&2
		exit 1
	fi
}

function concatenate {
	echo concatenating "$carrier" and "$secret"
	cat "$carrier" "$secret" > "$output"
}

function declareStegginVariables {
	endByte="$(wc -c $output | awk '{print $1}')"
	metaByte=$(($endByte + 1))
}

function getSha256Hashes {
	carSha="$(shasum -a 256 $carrier | awk '{print $1}')"
	secretSha="$(shasum -a 256 $secret | awk '{print $1}')"
}

function concatenateMetaDataText {
	echo "CARSHA: $carSha" > metaData.txt
	echo "SECSHA: $secretSha" >> metaData.txt
	echo "STARTBYTE: $startByte" >> metaData.txt
	echo "ENDBYTE: $endByte" >> metaData.txt
	echo "METABYTE: $metaByte" >> metaData.txt
	cat metaData.txt >> "$output"
}

function echoSucess {
	echo Meta File:
	cat metadata.txt && echo; echo
	echo "!!!!! Success file $secret is hidden in the file $output !!!!!"
}

function cleanup {
	rm metadata.txt
}

function readMetaDataText {
	validStegFileCheck="$(tail -c 500 $stegfile | grep -a 'SECSHA' | awk '{print $1}')"
	if [ "$validStegFileCheck" != "SECSHA:" ]; then
		echo "Error: File $stegfile has not been previously stegged." >&2
		exit 1
	fi
	secSha="$(tail -c 500 $stegfile | grep -a 'SECSHA' | awk '{print $2}')"
	carSha="$(tail -c 500 $stegfile | grep -a 'CARSHA' | awk '{print $2}')"
	startByte="$(tail -c 500 $stegfile | grep -a 'STARTBYTE' | awk '{print $2}')"
	endByte="$(tail -c 500 $stegfile | grep -a 'ENDBYTE' | awk '{print $2}')"
	METABYTE="$(tail -c 500 $stegfile | grep -a 'METABYTE' | awk '{print $2}')"
}

function extractSecretFile {
	head -c $endByte "$stegfile" | tail -c +"$startByte" > "$output"
	extractedSha="$(shasum -a 256 "$output" | awk '{print $1}')"
	echo "Original sha256:  $secSha"
	echo "Extracted sha256: $extractedSha"
	if [ "$extractedSha" = "$secSha" ]; then
		echo "SUCCESS: EXTRACTED FILE $output IS BYTE FOR BYTE IDENTICAL TO THE ORIGINALLY STEGGED FILE."
	else
		echo "WARNING: EXTRACTED FILE $output HAS BEEN MODIFIED SINCE ORIGINALLY STEGGED."
	fi
}

# Main Code
errorCases
if [[ -n "$carrier"  &&  -n "$secret" && -n "$output" ]]; then
	declareInitialVariables
	preventMultipleSteggin
	concatenate
	declareStegginVariables
	getSha256Hashes
	concatenateMetaDataText
	echoSucess
	cleanup
fi

# Split a file that hass been previously stegged.
if [[ -n "$stegfile" && -n "$output" ]]; then
	readMetaDataText
	extractSecretFile
fi

exit 0
