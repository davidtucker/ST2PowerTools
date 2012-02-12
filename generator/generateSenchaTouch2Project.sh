#!/bin/bash

##############
#
# AUTHOR
#
##############

# David Tucker
# Blog: http://www.davidtucker.net/
# Source: https://github.com/davidtucker/ST2PowerTools

##############
#
# LICENSE
#
##############

# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
# associated documentation files (the "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
# copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
# following conditions:

# The above copyright notice and this permission notice shall be included in all copies or substantial 
# portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT 
# LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN 
# NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

##############
#
# USER-EDITABLE VARIABLES
#
##############

# DIRECTORY WHERE TEMPLATE FILES ARE STORED
SENCHA_TEMPLATE_DIRECTORY="/Projects/LiveTemplates/templates"

############################################
# ----- DO NOT EDIT BELOW THIS LINE ------#
###########################################

##############
#
# VARIABLES
#
##############

# COLOR VARIABLES
#
# Color values will only be set if the term is defined and not 'dumb'

if [ "$TERM" != "" ] && [ "$TERM" != "dumb" ]; then
	COLOR_RED=$(tput bold)$(tput setaf 1)
	COLOR_BLUE=$(tput bold)$(tput setaf 4)
	COLOR_RESET=$(tput sgr0)
else
	COLOR_RED=""
	COLOR_BLUE=""
	COLOR_RESET=""
fi

# NAME VARIABLES

APP_NAME=""
APP_NAME_DEFAULT=${PWD##*/}
APP_NAME_ACCEPTABLE_REGEX="^([A-Za-z0-9 -]*)$"
APP_NAME_RULES="The name of the application can be made up of letters, number, spaces, and dashes.
No additional characters may be used.  The application name is used minimally in the 
default templates, and it shouldn't be confused with the namespace."

# NAMESPACE VARIABLES

APP_NAMESPACE=""
APP_NAMESPACE_DEFAULT=${PWD##*/}
APP_NAMESPACE_ACCEPTABLE_REGEX="^([A-Z]{1}[A-Za-z_0-9]*)$"
APP_NAMESPACE_RULES="The namespace is used throughout the application.  It needs to start with a 
capital letter and contain no spaces or special characters."

# SDK DIRECTORY VARIABLES

SENCHA_TOUCH_SDK_DEFAULT=""
SENCHA_TOUCH_SDK_ACCEPTABLE_REGEX="^(\.{1,2}[A-Za-z_ \/\.0-9-]*)$"
SENCHA_TOUCH_SDK_RULES="Please enter a relative path to the Sencha Touch 2 SDK directory. This cannot
 be an absolute path (so it cannot start with a '/')  This directory should contain the touch.jsb3 
file.  This directory will be validated after you enter the value to ensure that this file is present."
SENCHA_TOUCH_SDK_RELATIVE_PATH=""
SENCHA_TOUCH_SDK_RELATIVE_PATH_SPLIT=""

# PATH VARIABLES

OUTPUT_DIRECTORY=$(pwd)

##############
#
# FUNCTIONS
#
##############

###
# This function is designed to handle much of the logic involved with asking the user for a value
# and then validating that value.  It takes 4 parameters:
#
# 1: The prompt to the end user
# 2: The default value (which will be used if the user simply hits enter) - this will only be shown
# as a default value if it also passes validation
# 3: The regular expression for validation
# 4: The 'rules' that are given to the end user
###
GET_USER_INPUT_RESULT=""
function getUserInput {
	echo -e "$4\n"
	
	if [[ "$2" =~ $3 ]]; then
		DEFAULT_VALUE_DECLARATION="($2)"
	else
		DEFAULT_VALUE_DECLARATION=""
	fi
	
	echo -e "$1 $DEFAULT_VALUE_DECLARATION :: "
	read USER_INPUT_VALUE
	
	if [ "$USER_INPUT_VALUE" == "" ] && [ "$DEFAULT_VALUE_DECLARATION" != "" ]; then
		GET_USER_INPUT_RESULT=$2
		return 0
	fi
	
	if [[ "$USER_INPUT_VALUE" =~ $3 ]]; then
		GET_USER_INPUT_RESULT=$USER_INPUT_VALUE
	else
		echo -e "${COLOR_RED}INVALID ENTRY - PLEASE TRY AGAIN${COLOR_RESET} \n"
		getUserInput "$1" "$2" "$3" "$4"
	fi
}

###
# This function is designed to open a file from the template directory and create the same file in the
# output directory while also substituting in values for template variables.  The available template
# variables are defined below:
#
# %SENCHA_TOUCH_RELATIVE_DIRECTORY% - This is the relative path to the Sencha Touch 2 SDK
# %SENCHA_TOUCH_RELATIVE_DIRECTORY_SPLIT% - This is the relative path split into its parts (mainly for config.rb)
# %APPLICATION_NAME% - The name of the application
# %NAMESPACE_NAME% - The namespace defined for the application
#
# The function only takes one parameter (which is explained below):
#
# 1: The name of the file in the templates directory to act on for example: "index.html" or "resources/css/config.rb"
###
function parseAndReplaceVariables {
	sed -e "s;%SENCHA_TOUCH_RELATIVE_DIRECTORY%;$SENCHA_TOUCH_SDK_RELATIVE_PATH;" \
		-e "s;%SENCHA_TOUCH_RELATIVE_DIRECTORY_SPLIT%;$SENCHA_TOUCH_SDK_RELATIVE_PATH_SPLIT;" \
		-e "s;%APPLICATION_NAME%;$APP_NAME;" \
		-e "s;%NAMESPACE_NAME%;$APP_NAMESPACE;" \
		$SENCHA_TEMPLATE_DIRECTORY/$1 > $OUTPUT_DIRECTORY/$1
}

###
# This function is designed to process all files in the template directory, parse them and do variable substitution
# and then place them in the output directory.  This takes no parameters.
#
# It accomplishes this first by looping through all diectories in the template directory and then replicating that
# directory structure in the output directory.  It then loops through all of the files in the template directory
# and calls the parseAndReplaceVariables function on each of them.
###
function processAllTemplates {
	
	cd $SENCHA_TEMPLATE_DIRECTORY 
	
	# Creates Directory Structure in Output Directory
	find . -type d | while read DIR
	do
		mkdir $OUTPUT_DIRECTORY/$DIR
		echo "Created Directory: $DIR"
	done
	
	# Processes Files
	find . -type f | while read CURRENT_FILE
	do
		parseAndReplaceVariables $CURRENT_FILE
		echo "Copied and Parsed File: $CURRENT_FILE"
	done
	
	cd $OUTPUT_DIRECTORY
}

###
# This function validates the user's input for the relative path to the Sencha SDK.  This will check the
# directory to see if the touch.jsb3 file is present (since that was the most unique file / directory in
# the parent directory).  It will output appropriate messages if this validation fails.
###
function validateSenchaTouchSDKDirectory {
	cd $OUTPUT_DIRECTORY
	echo "Checking if file exists: $SENCHA_TOUCH_SDK_RELATIVE_PATH/touch.jsb3"
	if [[ -f "$SENCHA_TOUCH_SDK_RELATIVE_PATH/touch.jsb3" ]]; then
		echo "${COLOR_BLUE}The SDK Directory has been validated.${COLOR_RESET}"
		return 0;
	else
		echo "${COLOR_RED}The SDK Directory did not contain the touch.jsb3 file.  Please try again.${COLOR_RESET}"
		return 1;
	fi
}

###
# This function requests the relative SDK path from the end user.  In addition, it performs validation on
# this in two different ways.  First, the response is validated using a regular expression (as is commonly
# done in the getUserInput function), but then it also calls the validateSenchaTouchSDKDirectory to ensure
# that is indeed the correct directory.
###
function getSenchaSDKDirectory {
	getUserInput "Please enter a relative path to the Sencha SDK" "$SENCHA_TOUCH_SDK_DEFAULT" "$SENCHA_TOUCH_SDK_ACCEPTABLE_REGEX" "$SENCHA_TOUCH_SDK_RULES"
	SENCHA_TOUCH_SDK_RELATIVE_PATH=$GET_USER_INPUT_RESULT
	validateSenchaTouchSDKDirectory
	if [ $? -eq 0 ]; then
		splitDirectoryIntoComponentParts
		return 0;
	else
		getSenchaSDKDirectory
	fi
}

###
# This function takes a given relative path and separates it into a single-quoted comma-delimited list of
# directory elements.  This is used within the config.rb file.
#
# As an example, given the following directory: ../../SenchaTouch/sdk
# This method would set this value to the variable: '..','..','SenchaTouch','sdk'
###
function splitDirectoryIntoComponentParts {
	SENCHA_TOUCH_SDK_RELATIVE_PATH_SPLIT=${SENCHA_TOUCH_SDK_RELATIVE_PATH//\//\'\,\'}
	SENCHA_TOUCH_SDK_RELATIVE_PATH_SPLIT="'$SENCHA_TOUCH_SDK_RELATIVE_PATH_SPLIT'"
}

###
# This function asks the user a yes or no question (which you pass in).  This is then validated, and if the
# user does not answer either 'y' or 'n', it will re-ask the user.  The result will be set on the 
# USER_CONFIRMATION_VALUE variable, which can then be inspected after the function call.  The value of this
# variable will be either 'y' or 'n'.  This function takes one parameter:
#
# 1: The question to prompt the user with
###
function askForUserConfirmation {
	if [ "$1" != "" ]; then
		echo "$1 (y,n) :: "
	fi
	read USER_CONFIRMATION_VALUE
	if [ "$USER_CONFIRMATION_VALUE" != "y" ] && [ "$USER_CONFIRMATION_VALUE" != "n" ]; then
		echo "Please enter 'y' or 'n'"
		askForUserConfirmation
	fi
}

###
# This function validates that the template directory (which is configured by the end user) has an index.html
# and an app.js file.  This takes no parameters and will handle exiting out of the application if the directory
# is not valid.
###
function validateTemplatesDirectory {
	if [[ -f "$SENCHA_TEMPLATE_DIRECTORY/index.html" &&  -f "$SENCHA_TEMPLATE_DIRECTORY/app.js" ]]; then
		echo -e "${COLOR_BLUE}The Templates Directory is valid.${COLOR_RESET}\n\n"
		return 0
	else
		echo "${COLOR_RED}The template directory is not valid - it does not contain an index.html and app.js file.${COLOR_RESET}"
		exit 0
	fi
}

##############
#
# ACTUAL APP FLOW
#
##############

clear
echo "----------------------------------"
echo "${COLOR_BLUE}SENCHA TOUCH 2 PROJECT GENERATOR${COLOR_RESET}"
echo "----------------------------------"
echo ""
echo "Developed by David Tucker (http://www.davidtucker.net)"
echo "Project Hosted on Github (https://github.com/davidtucker/senchaTouch2Tools)"
echo "This code is licensed with an MIT License which can be viewed at 
http://www.opensource.org/licenses/mit-license.php"
echo ""
echo "----------------------------------"
echo ""
echo "This script generates the boilerplate code needed to start a Sencha Touch 2 project."
echo "The code will be generated in the current working directory."
echo "Output Path: $OUTPUT_DIRECTORY"

# Validate templates directory
validateTemplatesDirectory

# Confirm with the user that they want to continue
askForUserConfirmation "Do you want to proceed?"
if [ $USER_CONFIRMATION_VALUE == "n" ]; then
	exit 0
fi

echo -e "\n\n"

# Get the Name
echo "APPLICATION NAME"
echo "----------------------------------"
getUserInput "Please enter a name for your application" "$APP_NAME_DEFAULT" "$APP_NAME_ACCEPTABLE_REGEX" "$APP_NAME_RULES"
APP_NAME=$GET_USER_INPUT_RESULT
echo -e "\n"

# Get the Namespace
echo "APPLICATION NAMESPACE"
echo "----------------------------------"
getUserInput "Please enter a namespace name" "$APP_NAME" "$APP_NAMESPACE_ACCEPTABLE_REGEX" "$APP_NAMESPACE_RULES"
APP_NAMESPACE=$GET_USER_INPUT_RESULT
echo -e "\n"

# Get the Sencha Touch Relative Path
echo "SENCHA TOUCH SDK DIRECTORY"
echo "----------------------------------"
getSenchaSDKDirectory
echo -e "\n"

# Process all templates and generate parsed versions in output directory
echo "PROCESSING FILES AND TEMPLATES"
processAllTemplates

# We're all done
echo -e "\n"
echo "Your code has been generated and placed in $OUTPUT_DIRECTORY"

exit 0