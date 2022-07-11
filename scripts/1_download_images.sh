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

# This applications virtual environment and requirements.
ENV=download-images
REQS=download_requirements.txt

##############################################################
# Parse Positional Arguments
##############################################################
FILENAME=$1

if [ $2 ]
    then
		LIMIT="-l ${2}"
        echo "${2} pages will be downloaded from each document in ${FILENAME}."
    else 
		LIMIT=""
		echo "No limit was provided. All pages from each document in ${FILENAME} will be downloaded."
fi

##############################################################
# Reset Image and Data Directories
##############################################################
Setup()
{
	# Clear out (if necessary) and create and a new directory for images.
	if [ -d "img" ]
		then
		rm -r img
	fi
	mkdir img

	# Clear out (if necessary) and create and a new directory for XML files.
	if [ -d "data" ]
		then
		rm -r data
	fi
}

##############################################################
# Check and Activate the Virtual Environment
##############################################################
Activate_Venv()
{
	if [ -d ".venvs/${ENV}" ]
		then
		source ".venvs/${ENV}/bin/activate"
		REQS=$( cat reqs/${REQS} )
		PIP=$( pip freeze )
			if ! [[ $REQS == $PIP ]]
			then
			echo -e "${red}${inverted}The pipeline's installation is not complete.${reset}"
			echo -e "${inverted}Redirecting to the installation procedure.${reset}"
			bash install.sh
			echo -e "${inverted}Now ready to download images.${reset}"
			fi
		else
		echo -e "${red}${inverted}Installation of pipeline is not complete.${reset}"
		echo -e "${inverted}Redirecting to the installation procedure.${reset}"
		bash install.sh
		echo -e "${inverted}Now ready to download images.${reset}"
	fi
	source ".venvs/${ENV}/bin/activate"
}

##############################################################
# Main Program
##############################################################
echo -e "\n${inverted} Phase 1. Download images from Gallica.${reset}"

# Reset the image (./img/) and data (./data/) directories.
Setup

# Activate the virtual environment in ./.venvs/
echo -e "\nActivating virtual environment..."
Activate_Venv
echo -e "${yellow}Virtual environment '${ENV}' activated.${reset}"

# Parse the ARKs listed in the file given after option -f
for ARK in `cat $FILENAME`;
do
	echo -e "\n${inverted}Gathering images from document with ARK $ARK.${reset}"
	STARTTIME=$(date +%s)
 		echo -e "\nDownload in progress...\nCheck the document's folder in img/ to see new downloads arrive."
 		# Script from https://github.com/carolinecorbieres/Memoire_TNAH/tree/master/2_Workflow/1_ImportCatalogues
 		# by Simon Gabay and Caroline Corbières.
 		# I have modified the script's options by adding "-e", which allows us to specify the export location.
 		python scripts/import_iiif.py ark:/12148/$ARK $LIMIT -e img
 		ENDTIME=$(date +%s)
		COUNT=`ls ./img/${ARK} | wc -l`
 		echo -e "${green}${COUNT} pages were downloaded in $(($ENDTIME - $STARTTIME)) seconds.${reset}"
done

# Deactivate the virtual environment for downloading images.
deactivate
echo -e "\n${yellow}Virtual environment '${ENV}' deactivated.${reset}"
