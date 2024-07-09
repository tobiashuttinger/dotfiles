#!/usr/bin/env zsh

# Store the current non-sudo user
currentUser=$(id -un)

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this scriptApp has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


###############################################################################
# Anti spy config                                                             #
###############################################################################

# Block apple OCSP service (verifies cert on every app launch with apple servers)
sudo sh -c 'echo "127.0.0.1 ocsp.apple.com" >> /etc/hosts'
sudo sh -c 'echo "127.0.0.1 ocsp2.apple.com" >> /etc/hosts'


###############################################################################
# Configure zsh and terminal                                                  #
###############################################################################

# Copy zsh config
cp ./zsh/zshrc ~/.zshrc
chmod 644 ~/.zshrc
# Copy zsh plugins
mkdir ~/.zsh
cp -R ./zsh/zsh-plugins/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
cp -R ./zsh/zsh-plugins/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
chmod -R 744 ~/.zsh

# Terminal
cp ./terminal/com.apple.Terminal.plist ~/Library/Preferences/com.apple.Terminal.plist
chmod 600 ~/Library/Preferences/com.apple.Terminal.plist


###############################################################################
# Install packages                                                            #
###############################################################################

sudo mkdir -p /usr/local/bin/
sudo chmod -R ${currentUser}:admin /usr/local/bin

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install tmux inetutils moreutils findutils wget curl httpie htop bmon nmap iperf rclone rsync p7zip hexedit git python@3.9 go rust node ffmpeg ffmpeg@2.8 libusb mediainfo exiftool cmake qt ninja yt-dlp neofetch ncdu mpv openssl f3 watch libimobiledevice openjdk mitmproxy fsevent_watch monolith chromium shairport-sync docker docker-compose
brew cleanup
