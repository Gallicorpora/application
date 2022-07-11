#!/bin/bash

# -----------------------------------------------------------
# Code by: Kelly Christensen
# Bash script to convert ALTO XML files to a TEI XML document.
# -----------------------------------------------------------

# Color codes for console messages.
bold='\033[1m'
reset='\033[0m'
inverted="\033[7m"
red="\033[31m"
green="\033[32m"
yellow="\033[33m"

# This applications virtual environment and requirements.
ENV=alto2tei
REQS=alto2tei_requirements.txt

##############################################################
# Reset Image and Data Directories
##############################################################
Setup()
{
	# Check that the transcriptions were made.
	if ! [ -d 'data' ]
		then
			echo -e "${red}Error. No transcriptions were created. Missing ALTO XML files in data/.${reset}"
			exit
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
			echo -e "${inverted}Now ready to convert transcriptions to TEI.${reset}"
			fi
		else
		echo -e "${red}${inverted}Installation of pipeline is not complete.${reset}"
		echo -e "${inverted}Redirecting to the installation procedure.${reset}"
		bash install.sh
		echo -e "${inverted}Now ready to convert transcriptions to TEI.${reset}"
	fi
	source ".venvs/${ENV}/bin/activate"
}

##############################################################
# Get the version of Kraken
##############################################################
# Search for kraken in a requirements file and store the match without the file name.
KRAKEN=`grep -Eho 'kraken==([\.|0-9]+)' reqs/*`

# Check that the version number was found in the grep result.
regex="[\.|0-9]+"
if [[ $KRAKEN =~ $regex ]]
    # Subtract "kraken==" from the string, leaving only the version number.
    then
    VERSION=`grep -Eho 'kraken==([\.|0-9]+)' reqs/* | sed 's/kraken==//'`
fi
echo $VERSION

##############################################################
# Main Program
##############################################################
echo -e "\n${inverted}Phase 3. Convert transcribed ALTO XML files to a TEI XML document.${reset}"

# Check that there is data in the directory './data/'
Setup

# Activate the virtual environment in ./.venvs/
echo -e "\nActivating virtual environment..."
Activate_Venv
echo -e "${yellow}Virtual environment '${ENV}' activated.${reset}"

# Run the application alto2tei.
python scripts/alto2tei.py --config config.yml --version $VERSION --header --sourcedoc --body

# Deactivate the virtual environment for creating the TEI document.
deactivate
