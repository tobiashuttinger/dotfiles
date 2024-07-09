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
# System                                                                      #
###############################################################################

# Disable gatekeeper
sudo spctl --master-disable

# Disable screensaver
defaults -currentHost write com.apple.screensaver idleTime 0

# Optional: Enable trim for non apple sata ssds
# trimforce enable


###############################################################################
# General UI/UX                                                               #
###############################################################################

# Only show scrollbars when scrolling
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Make whole windows draggable with Cmd + Ctrl
defaults write -g NSWindowShouldDragOnGesture -bool true

# Disable hot corners
defaults write com.apple.dock wvous-tl-corner -int 1
defaults write com.apple.dock wvous-tr-corner -int 1
defaults write com.apple.dock wvous-bl-corner -int 1
defaults write com.apple.dock wvous-br-corner -int 1


###############################################################################
# Trackpad, mouse, keyboard, bluetooth accessories, and input                 #
###############################################################################

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
# Trackpad: enable dragging with three fingers
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
# Trackpad: disable two finger smart zoom
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -bool false

# Keyboard increase key repeat speed
defaults write -g KeyRepeat -float 2

# Keyboard activate "hold key to repeat letter"
defaults write -g ApplePressAndHoldEnabled -bool false

# On Sonoma, disable the new keyboard language switcher
defaults write kCFPreferencesAnyApplication TSMLanguageIndicatorEnabled 0

# Disable autocorrect and text completion, for some apps this must be set individually
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write com.apple.mail NSAutomaticSpellingCorrectionEnabled -bool false
defaults write com.apple.notes NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticTextCompletionEnabled -bool false
defaults write com.apple.mail NSAutomaticTextCompletionEnabled -bool false
defaults write com.apple.notes NSAutomaticTextCompletionEnabled -bool false
# Without WebAutomaticSpellingCorrectionEnabled, Mail still corrects spelling
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false
defaults write com.apple.mail WebAutomaticSpellingCorrectionEnabled -bool false
defaults write com.apple.safari WebAutomaticSpellingCorrectionEnabled -bool false

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Set language and text formats
defaults write NSGlobalDomain AppleLanguages -array "de"
defaults write NSGlobalDomain AppleLocale -string "de_DE@currency=EUR"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

# Set the timezone; see `sudo systemsetup -listtimezones` for other values
sudo systemsetup -settimezone "Europe/Berlin" > /dev/null

# Add keyboard shortcut to open terminal at folder with cmd + shift + < on ISO keyboards 
defaults write pbs NSServicesStatus -dict-add '"com.apple.Terminal - New Terminal at Folder - newTerminalAtFolder"' '{"key_equivalent" = "@$`";}'


###############################################################################
# Power settings                                                              #
###############################################################################

# Disable turning off display
sudo pmset -a displaysleep 0

# Disable machine sleep while charging
sudo pmset -c sleep 0

# Optional: Disable machine sleep on battery
# sudo pmset -b sleep 0

# Optional: Set standby delay to 24 hours (default is 1 hour)
# sudo pmset -a standbydelay 0

# Optional: Never go into computer sleep mode
# sudo systemsetup -setcomputersleep Off > /dev/null

# Optional: Hibernation mode
# 0: Disable hibernation (speeds up entering sleep mode)
# 3: Copy RAM to disk so the system state can still be restored in case of a
#    power failure.
# sudo pmset -a hibernatemode 0

# Optional: Remove the sleep image file to save disk space
# sudo rm /private/var/vm/sleepimage
# Optional: Create a zero-byte file instead…
# sudo touch /private/var/vm/sleepimage
# Optional: …and make sure it can’t be rewritten
# sudo chflags uchg /private/var/vm/sleepimage


###############################################################################
# Finder                                                                      #
###############################################################################

# Set home folder as the default location for new Finder windows
# For desktop, use `PfDe` and `file://${HOME}/Desktop`
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Set the default view style for folders without custom setting
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"

# Configure icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool false
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Show the ~/Library folder
chflags nohidden ~/Library


###############################################################################
# Spotlight                                                                   #
###############################################################################

# Disable indexing for all volumes except os
sudo mdutil -i off /Volumes/*
sudo mdutil -i on /

# Rebuild the index from scratch
sudo mdutil -E /


###############################################################################
# Time Machine                                                                #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Optional: Disable local Time Machine backups (requires full disk access for terminal)
# hash tmutil &> /dev/null && sudo tmutil disable


###############################################################################
# Appstore & Updates                                                          #
###############################################################################

# Disable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool false

# Don't check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 0

# Don't download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 0

# Don't install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 0

# Don't automatically download apps purchased on other Macs
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 0

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool false

# Allow the App Store to reboot machine on macOS updates
defaults write com.apple.commerce AutoUpdateRestartRequired -bool false


###############################################################################
# Apply settings                                                              #
###############################################################################

/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
echo "Done configuring base system settings."