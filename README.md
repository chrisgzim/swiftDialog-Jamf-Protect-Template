# swiftDialog-Jamf-Protect-Template
## A simple way to put all of your remediations in one script!

One of the coolest features of Jamf Protect is the ability to partner with Jamf Pro for remediation. The way this is accomplished is through smart groups and policies that are scoped to machines that have a Jamf Protect EA tied to them.

A cool project out there is from @bartreardon: swiftDialog. The goal of this script was to make a simple template that would notify end-users of potential threats and remediation progress.

This is my first experience using swiftDialog and it is a really sweet project. Hope this is a helpful resource for Mac Admins! 

(The script will check to see if swiftDialog is installed, if not it will install it for you.)

## How to Use

For the most part, everything that you need to change is all at the beginning of the script. My goal was to make this as simple as possible for admins. Just copy your remediation scripts and paste them into the template. 

By default, there are only three remediations spots. However, I have added templates for up to 7 as well as a way to simply add your script to the remediation function. (There is also a template you can use to add as many as you would like! 

Just want to test the swiftDialog prompts? No problem! There is now a Debug Mode that you can use to help see what the different prompts look like. Each instance of "remediation" in debug will go ahead and run a sleep command for 5 seconds. (This way you can see the progress bar move as well.) 

Hopefully you find this helpful and as always, please give some feedback! 

## Screenshots of default behavior: 

### Intial Warning
<img width="1440" alt="Screenshot 2023-05-12 at 12 39 38 PM" src="https://github.com/chrisgzim/swiftDialog-Jamf-Protect-Template/assets/101137859/59de368a-291c-4733-b961-65b9491a8e2c">

### Remediation Progress
<img width="1440" alt="Screenshot 2023-05-12 at 12 42 42 PM" src="https://github.com/chrisgzim/swiftDialog-Jamf-Protect-Template/assets/101137859/2e6eafbd-1f4a-4deb-868b-eb63712a7b5d">

### Remediation Complete
<img width="1440" alt="Screenshot 2023-05-12 at 12 42 56 PM" src="https://github.com/chrisgzim/swiftDialog-Jamf-Protect-Template/assets/101137859/fccba0b0-f76e-4efd-94f3-dab6a49b64b3">
