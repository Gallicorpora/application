#!/bin/bash

# -----------------------------------------------------------
# Code by: Kelly Christensen
# Bash script to run 3 phases of Gallicorpora pipeline.
# -----------------------------------------------------------

# Color codes for console messages.
bold='\033[1m'
reset='\033[0m'
inverted="\033[7m"
red="\033[31m"
green="\033[32m"
yellow="\033[33m"

clear
echo -e "${bold} _______________________________________________ ${reset}"
echo -e "${bold}| Launching the Gallic(orpor)a Project Pipeline |${reset}"
echo -e "${bold} ----------------------------------------------- ${reset}"
echo ""

#####################################################################
# Help
#####################################################################
Help()
{
    # Display help
    echo "Launch the Gallic(orpor)a Pipeline."
    echo
    echo "Syntax: process.sh [-h|f|l]"
    echo "options:"
    echo "h    Print this Help."
    echo "f    Path to the text file that contains a list of Archival Resource Keys (ARK) for documents on Gallica."
    echo "l    Numerical limit applied to the number of pages downloaded from each document on Gallica."
    echo
}

##############################################################
# Get Options
##############################################################

# Loop through all the options declared when calling this script.
while getopts "hf:l:" option; do
    case $option in
        h) # Display help message.
            Help
            exit;;
        f) # Get name of file containing ARKs.
            Filename=$OPTARG;;
        l) # Get limit of images to be downloaded
            Limit=$OPTARG;;
        \?) # Invalid option
            echo "Error: Invalid option"
            exit;;
    esac
done
if [ -z "$Filename" ]; then
    echo "Exited program."
    echo -e "${red}Error. A file containing Archival Resource Keys (ARK) must be provided after the option -f.${reset}"
    echo "In your last command, the parameters provided after process.sh were: ${*}"
    exit
fi

##############################################################
# Main Program
##############################################################

# 1. Download images from Gallica
bash scripts/1_download_images.sh $Filename $Limit

# 2. Transcribe images
bash scripts/2_transcribe_images.sh

# 3. Convert to TEI
bash scripts/3_alto2tei.sh
