#!/usr/bin/env zsh

# Store the current non-sudo user
currentUser=$(id -un)

# Close any open System Preferences panes, to prevent them from overriding
# settings this script is about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


###############################################################################
# Configure network                                                           #
###############################################################################

# Set computer name
sudo scutil --set ComputerName "tobimac"
sudo scutil --set HostName "tobimac"
sudo scutil --set LocalHostName "tobimac"

# Network setup - requires a default 'Ethernet' network to be present
networksetup -setmanual Ethernet 192.168.1.213 255.255.255.0 192.168.1.222
networksetup -setdnsservers Ethernet 192.168.1.230 fd00:1234:567a:1::2

networksetup -createnetworkservice Localv6 Ethernet
networksetup -setv4off Localv6
networksetup -setv6manual Localv6 fd00:1234:567a:1::5 64


###############################################################################
# Apply settings                                                              #
###############################################################################

/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
echo "Done configuring network settings."