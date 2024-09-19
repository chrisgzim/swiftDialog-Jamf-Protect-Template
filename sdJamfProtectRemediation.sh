#!/bin/bash

#### JAMF PROTECT REMEDIATION WITH SWIFTDIALOG TEMPLATE ####
#
# A simple way to put in your Jamf Protect / Pro Remediations
# in a single script
#
# First a huge shoutout to @robjschroeder for the idea for this script
#
# This project would not be possible without the amazing work of @bartreardon
# and the awesomeness of swiftDialog
#
# Definitely have to give a shoutout to @dan-snelson for some help with putting this together
# You should absolutely check out Setup Your Mac
# 
# 
#
# This is a script I wrote for fun, it has no affliation with Jamf 
# and is not a part of their support. 
#############################################################


########### WHAT NEEDS TO BE FILLED OUT #################
#### Parameters for Jamf #####

# File Path / URL to Icon -- Defaults to the Jamf Protect Logo
icon="${4:-"/Applications/JamfProtect.app/Contents/Resources/AppIcon.icns"}"
#Have the Script do the cleanup of the smart groups (/Library/Application Support/JamfProtect/Groups/(group) 
#Will keep groups that do not have a remediation
SmartGroupCleanup="${5:-"true"}" # set to true by default. To turn off, use any value you want other than true.
# Debug Mode -- will add the groups as necessary, give you a feel for the dialogs / progress bar and run all remediations as sleep commands
debugMode="$6" # Set Debug to true to enable #To test out errors / non-matching variables use the fe+=() variable
# File path for Log File
logfile="${7:-"/var/log/protectremediation.txt"}"


###### Paramaters for swiftDialog ###############
#Headline for the Warning
titletext="Warning"
#Main Text for Warning
message="Your computer has detected a potential threat. Please click OK so that we can make sure that your computer is safe to use."
#Title Text for Remediation
title="Protecting your Mac"
#Main Text for Remediation
remediatemessage="Please wait. Remediation in Progress. . ."
#Headline for Remediation
completiontitle="Remediation Complete"
#Main Text for Completion
completiontext="Your Mac is now safe"
############# SwiftDialog Paramaters End ########

################ LOG FUNCTION ###################
function updatelog() {
    echo -e "$( date +%Y-%m-%d\ %H:%M:%S ) - ${1}" | tee -a "${logfile}"
}
# you can use this with your remediation scripts too #
################################################

########## Remediation Workflow(s) ############
########## VARIABLES TO EDIT HERE #######
########## Instead of an exit 1, you can use 
########## ((err++)) to track failed remediations 

##### Three Remediations by default ###########
####

# Name of a Group
sg[1]=""
function remediate1() {
    sleep 5 # Put your Remdiation Script Here
}
# Name of a Group
sg[2]=""
function remediate2() {
    sleep 5 #Put your Remediation Script Here
}
# Name of a Group
sg[3]=""
function remediate3() {
    sleep 5 #Put your Remediation Script Here
}

####### Extra Remediation Spots ##############
###### Includes instructions of things to add
###### to the remediationwork function as well
###### If you need more, a solid template 
###### is provided for you. 
#############################################

# Name of a Group
#sg[4]=""
#function remediate4() {
#   sleep 5 #Put your Remediation Script Here
#}

### If using add this to the script ###
### Without comments of course ########

#${sg[4]})
#   #dialogupdateProtectRemediation "progresstext: $result or message here"
#   remediate4
#   ((rc++))
#   ;;

# Name of a Group
#sg[5]=""
#function remediate5() {
#   sleep 5 #Put your Remediation Script Here
#}

### If using add this to the script ###
### Without comments of course ########

#${sg[5]})
#   #dialogupdateProtectRemediation "progresstext: $result or message here"
#   remediate5
#   ((rc++))
#   ;;


## Name of a Group
#sg[6]=""
#function remediate6() {
#   sleep 5 #Put your Remediation Script Here
#}

### If using add this to the script ###
### Without comments of course ########

#${sg[6]})
#   #dialogupdateProtectRemediation "progresstext: $result or message here"
#   remediate6
#   ((rc++))
#   ;;

# Name of a Group
#sg[7]=""
#function remediate7() {
#   sleep 5 #Put your Remediation Script Here
#}

### If using add this to the script ###
### Without comments of course ########

#${sg[7]})
#   #dialogupdateProtectRemediation "progresstext: $result or message here"
#   remediate7
#   ((rc++))
#   ;;

##### TEMPLATE if going over 7 ############# (copy and make changes) 
# Name of a Group
#sg[#]=""
#function remediate#() {
#   sleep 5 #Put your Remediation Script Here
#}

### If using add this to the script ###
### Without comments of course ########

#${sg[#]})
#   #dialogupdateProtectRemediation "progresstext: $result or message here"
#   remediate#
#   ((rc++))
#   ;;


############### WHAT NEEDS TO BE FILLED OUT END ############################

##############################################################################
#
# If you need to add more remediations, please follow the instructions listed
# in the remediation category of things to fill out.                         #
##############################################################################
########## You can add "progress text" using the first line that is commented out in the 
########## cased remediation. 
##############################################################################

function remediationwork() {
    if [[ $SmartGroupCleanup == "true" ]]; then updatelog "Smart Group Cleanup Enabled, will clean up after each remediation"; fi
    for result in ${gtr[@]}; do
        #Variable needed for the Progress Bar
        piv=$(( 100 / er ))
            case $result in
                
                #replace "group" variable with Smart Group Tag, replace remediate with workflow for remediation
                #leave the arithemetic variables as those help with tracking progress
                ${sg[1]})
                    #dialogupdateProtectRemediation "progresstext: $result or message here"
                    remediate1
                    ((rc++))
                ;;
                ${sg[2]})
                    #dialogupdateProtectRemediation "progresstext: $result or message here"
                    remediate2
                    ((rc++))
                ;;
                ${sg[3]})
                    #dialogupdateProtectRemediation "progresstext: $result or message here"
                    remediate3
                    ((rc++))
                ;;
                *)
                    #dialogupdateProtectRemediation "progresstext: Unknown Remediation"
                    updatelog "remediation not found for $result"
                    ((rc++))
                    ((err++))
                ;;
            esac
        #If Clean up is enabled, clean up
        if [[ $SmartGroupCleanup == "true" ]]; then
            # Makes sure your remediation didn't already delete the file ;)
            if [[ -e "$jpgd"/${result} ]] && [[ $errcheck = $err ]]; then
                updatelog "Removing $result from the $jpgd folder"
                rm -r "$jpgd/${result}"
            else
                updatelog "Could Not Delete $result (No Remediation Present or Remediation Failed)"
                #resets the error check
                errcheck=$((err))
            fi
            
        fi
            # Increment the progress bar
            dialogupdateProtectRemediation "progress: increment ${piv}"
        done
    dialogupdateProtectRemediation "button1: enable"
}



####### DEBUG FUNCTIONS ###############


#### DEBUG Variable #######
##### Fake Errors Array ###
##### Use this to add "Unknown Remediation Errors in Debug Mode
##### Simply type in values like so ( Fake Errors Go Here )
fe+=()
###########################


function debugsetup() {
    # Write Group Files if not already there to maximize the prompts 
    for groupstomake in ${sg[@]}; do
        if [[ ! -e "$jpgd"/$groupstomake ]]; then
            updatelog "DEBUG: Creating the $groupstomake file now"
            touch "$jpgd"/$groupstomake
        else
            updatelog "DEBUG: There is already a $groupstomake here"
        fi
    done
    # Creating Fake Groups if added in the fe array
    if [[ -z ${fe[@]} ]]; then
        updatelog "DEBUG: No fake groups added to the fe array"
    else
        for fakegroups in ${fe[@]}; do
            if [[ -e $fakegroups ]]; then
                updatelog "DEBUG: $fakegroups already detected, skipping for now"
            else
                updatelog "DEBUG: Adding $fakegroups to Protect Groups"
                touch "$jpgd"/$fakegroups
            fi
        done
    fi
}

function debugremediation() {
    updatelog "DEBUG: Creating a test for ${#gtr[@]} remediations"
    for result in ${gtr[@]}; do
        #Variable needed for the Progress Bar
        piv=$(( 100 / er ))
        case ${sg[@]} in
            
            #leave the arithemetic variables as those help with tracking progress
            (*"$result"*)
                debugupdate "progresstext: DEBUG: Doing Fake Remediation for $result"
                sleep 5
                updatelog "DEBUG: Faking the remediation for $result"
                ((rc++))
            ;;
            *)
                debugupdate "progresstext: DEBUG Unknown Remediation for $result"
                sleep 5
                updatelog "DEBUG: There does not appear to be a remediation for $result"
                ((rc++))
                ((err++))
            ;;
        esac
        #If Clean up is enabled, clean up
        if [[ $SmartGroupCleanup -eq 1 ]]; then
            # Makes sure your remediation didn't already delete the file ;)
            if [[ -e "$jpgd"/${result} ]] && [[ $errcheck = $err ]]; then
                updatelog "DEBUG: SMARTGROUPCLEANUP ENABLED Deleting the $result from Protect Groups"
                rm -r "$jpgd"/${result}
                
            else
                updatelog "DEBUG: SMARTGROUPCLEANUP ENABLED but Could Not Delete $result (No Remediation Present or Remediation Failed)"
                #resets the error check
                updatelog "DEBUG: Resetting Error Check to Continue Calculations"
                updatelog "DEBUG: $errcheck does not equal $err"
                errcheck=$((err))
                updatelog "DEBUG: $errcheck equals $err"
            fi
            
        fi
        # Increment the progress bar
        debugupdate "progress: increment ${piv}"
    done
    debugupdate "button1: enable"

}

function debugcomplete() {
    
    debugupdate "title: DEBUG MODE $completiontitle"
    debugUpdate "message: $completiontext"
    debugupdate "progresstext: Your Mac is Safe Now"
    debugupdate "progress: complete"
    debugupdate "button1: enable"
    debugupdate "button1text: Continue"
    
    sleep 10
}
######## Scripting Logic for the workflow ################
### This is where the magic happens, please do not touch ####
#######################################################
#Check for log file and create one if it doesn't exist

if [[ ! -e $logfile ]]; then
    touch $logfile
    echo "No log file found, creating now"
fi

updatelog "Jamf Protect Template: Start of Log"


# Validate swiftDialog is installed

if [ ! -e "/Library/Application Support/Dialog/Dialog.app" ]; then
    updatelog "Dialog not found, installing..." 
    dialogURL=$(curl -L --silent --fail "https://api.github.com/repos/swiftDialog/swiftDialog/releases/latest" | awk -F '"' "/browser_download_url/ && /pkg\"/ { print \$4; exit }")
    expectedDialogTeamID="PWA5E9TQ59"
    # Create a temp directory
    workDir=$(/usr/bin/basename "$0")
    tempDir=$(/usr/bin/mktemp -d "/private/tmp/$workDir.XXXXXX")
    # Download latest version of swiftDialog
    /usr/bin/curl --location --silent "$dialogURL" -o "$tempDir/Dialog.pkg"
    # Verify download
    teamID=$(/usr/sbin/spctl -a -vv -t install "$tempDir/Dialog.pkg" 2>&1 | awk '/origin=/ {print $NF }' | tr -d '()')
    if [ "$expectedDialogTeamID" = "$teamID" ] || [ "$expectedDialogTeamID" = "" ]; then
        /usr/sbin/installer -pkg "$tempDir/Dialog.pkg" -target /
    else
        updatelog "Team ID verification failed, could not continue..."
        exit 6
    fi
    /bin/rm -Rf "$tempDir"
else
    updatelog "Dialog v$(dialog --version) installed, continuing..."
fi

### Swift Dialog Binary and Application Location ####
dialogBinary="/usr/local/bin/dialog"
dialogApp="/Library/Application\ Support/Dialog/Dialog.app/Contents/MacOS/Dialog"

#jamfprotect groups directory
jpgd="/Library/Application Support/JamfProtect/groups"

# Create files if they don't exist if Debug is Enabled 
if [[ $debugMode = "true" ]]; then
    updatelog "DEBUG MODE: Debug Mode Enabled adding all of the Groups" 
    debugsetup
fi

#Make sure directory exists and grab the groups that need to be resolved
if [[ -d "$jpgd" ]]; then
    #groups to remediate
    updatelog "Groups Identified. . . adding to array for remediation"
    gtr+=($(/bin/ls "$jpgd"))
else
    updatelog "Directory Not found, unable to remediate"
    exit 1
fi

#expected remediations
er=$(echo ${#gtr[@]})
#variables to track progress (remediation complete)
rc=0
# Errors
err=0
errcheck=0


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

######## DEBUG Resources #############

### Command File for swiftDialog ###

debugcommandfile=$( mktemp /var/tmp/dbprotectremediation.XXX )
debugwelcomecommandfile=$( mktemp /var/tmp/dbprotectremediation.XXX )

## Welcome / Beginning Prompt Dialog
debugbeginningprompt="$dialogBinary \
--title \"DEBUG MODE $titletext\" \
--message \"$message\" \
--icon \"$icon\" \
--button1text \"OK\" \
--ontop \ "

## Remediation Prompt
debugremediationtime="$dialogBinary \
--title \"DEBUG MODE $title\" \
--message \"$remediatemessage\" \
--icon \"$icon\" \
--progress \
--progresstext \"Remediating Vulnerabilities\" \
--button1text \"Wait\" \
--button1disabled \
--quitkey k \
--ontop \
--commandfile \"$debugcommandfile\" "



#### Update Progress on Command File
function dialogupdateProtectRemediation() {
    echo "$1" >> "$commandfile"
}

function debugupdate() {
    echo "$1" >> "$debugcommandfile"
}

### Clean up your Mess ###

function fin() {
    if [[ $debugMode = "true" ]]; then
        updatelog "DEBUG MODE: Deleting tmp files"
        rm -r $debugcommandfile
        rm -r $debugwelcomecommandfile
    else
        updatelog "Removing tmp files"
        rm -r $commandfile
        rm -r $welcomecommandfile
    fi
    
    updatelog "Clean up complete"
    updatelog "Jamf Protect Template: End of Log"
}

#Creates Working Files
if [[ $debugMode = "true" ]]; then
    updatelog "DEBUG MODE: Creating Debug Command File"
    echo "$debugremediationtime" >> $debugcommandfile
else
    echo "$remediatetime" >> $commandfile
fi

#starts progress bar
if [[ $debugMode = "true" ]]; then
    debugupdate "progress: 1"
else
    dialogupdateProtectRemediation "progress: 1"
fi

########## SWIFT DIALOG FOR COMPLETION MESSAGE ############
function completion() {
    
    dialogupdateProtectRemediation "title: $completiontitle"
    dialogupdateProtectRemediation "message: $completiontext"
    dialogupdateProtectRemediation "progresstext: Your Mac is Safe Now"
    dialogupdateProtectRemediation "progress: complete"
    dialogupdateProtectRemediation "button1: enable"
    dialogupdateProtectRemediation "button1text: Continue"
    
    sleep 10
}
###########################################################

#### Do the Work #################
if [[ $debugMode = "True" ]]; then
    eval ${debugbeginningprompt}
    eval ${debugremediationtime[*]} & sleep 0.3
    debugremediation
    debugcomplete
else
    eval ${beginningprompt}
    eval ${remediationtime[*]} & sleep 0.3
    remediationwork
    completion
fi
###################################

fin