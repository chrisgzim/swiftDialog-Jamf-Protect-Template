#!/bin/bash

#### JAMF PROTECT REMEDIATION WITH SWIFTDIALOG TEMPLATE ####
# 
# A simple way to put in your Jamf Protect / Pro Remediations 
# in a single script
#
#############################################################

#### Parameters for Jamf #####
# File Path / URL to Icon
icon="$4"
#Headline for the Warning
titletext="$5"
#Main Text for Warning
message="$6"
#Title Text for Remediation
title="$7"
#Main Text for Remediation
remediatemessage="$8"
#Headline for Remediation
completiontitle="$9"
#Main Text for Completion
completiontext="${10}"


# Clean up Jamf Protect Smart Groups
# Dont have to use if you're already doing this in your remediations
SmartGroupCleanup="${11}" #Set parameter to 1 for "True" 

######## END JAMF PARAMATERS ####

########## Remediation Workflow(s) ######### 
########## VARIABLES TO EDIT HERE #######

function remediationwork() {
	for result in ${gtr[@]}; do
		#Variable needed for the Progress Bar
		piv=$(( 100 / er ))
			case $result in
				
				#replace "group" variable with Smart Group Tag, replace remediate with workflow for remediation
				#leave the arithemetic variables as those help with tracking progress
				group1)
					remediate
					((rc++))
				;;
				group2)
					remediate
					((rc++))
				;;
				group3)
					remediate
					((rc++))
				;;
				*)
					echo "remediation not found for $result" >> $logfile
					((rc++))
					((err++))
				;;
			esac
		#If Clean up is enabled, clean up
		if [[ $SmartGroupCleanup -eq 1 ]]; then
			# Makes sure your remediation didn't already delete the file ;)
			if [[ -e $jpgd/$result ]]; then
				rm -r $jpgd/$result
			fi
			
		fi
			# Increment the progress bar
			dialogupdateProtectRemediation "progress: increment ${piv}"
		done
	dialogupdateProtectRemediation "button1: enable"
}

######## Scripting Logic for the workflow ########
### This is where the magic happens, please do not touch ####

### Swift Dialog Binary and Application Location ####
dialogBinary="/usr/local/bin/dialog"
dialogApp="/Library/Application\ Support/Dialog/Dialog.app/Contents/MacOS/Dialog"

#jamfprotect groups directory
jpgd=/Library/Application\ Support/JamfProtect/groups
#Make sure directory exists and grab the groups that need to be resolved 
if [[  -d "$jpgd" ]]; then
	#groups to remediate
	gtr+=($(/bin/ls "$jpgd"))
else
	echo "Directory Not found, unable to remediate"
	exit 1
fi

#expected remediations
er=$(echo ${#gtr[@]})
#variables to track progress (remediation complete)
rc=0
# Errors
err=0
# Path to a log file
logfile=/tmp/protectremediation.txt

#Check for log file and create one if it doesn't exist
if [[ ! -e $logfile ]]; then
	touch $logfile
	echo "No log file found, creating now"
fi

######### SWIFT DIALOG FUNCTIONS ########

### Command File for swiftDialog ###

commandfile=$( mktemp /var/tmp/protectremediation.XXX )
welcomecommandfile=$( mktemp /var/tmp/protectremediation.XXX )

## Welcome / Beginning Prompt Dialog
beginningprompt="$dialogBinary \
--title \"$titletext\" \
--message \"$message\" \
--icon \"$icon\" \
--button1text \"OK\" \ 
--blurscreen \
--ontop \ "

## Remediation Prompt
remediationtime="$dialogBinary \
--title \"$title\" \
--message \"$remediatemessage\" \
--icon \"$icon\" \
--progress \
--progresstext \"Remediating Vulnerabilities\" \
--button1text \"Wait\" \
--blurscreen \
--button1disabled \
--quitkey k \
--ontop \
--commandfile \"$commandfile\" "


#### Update Progress on Command File
function dialogupdateProtectRemediation() {
	echo "$1" >> "$commandfile"
}

#Creates Working Files
echo "$remediatetime" >> $commandfile

#starts progress bar
dialogupdateProtectRemediation "progress: 1"

########## SWIFT DIALOG FOR COMPLETION MESSAGE ############
function completion() {
	
	dialogupdateProtectRemediation "title: $completiontitle"
	dialogupdateProtectRemediation "message: $completiontext"
	dialogupdateProtectRemediation "progresstext: Your Mac is Safe Now"
	dialogupdateProtectRemediation "progress: complete"
	dialogupdateProtectRemediation "button1: enable"
	dialogupdateProtectRemediation "button1text: Continue"
	
}
###########################################################

#### Do the Work ######
eval ${beginningprompt}
eval ${remediationtime[*]} & sleep 0.3
remediationwork 
completion
###################################

