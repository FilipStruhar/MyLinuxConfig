#!/bin/bash

# Install curl package
echo "Installing curl..."
echo " "

if command -v apt-get > /dev/null; then
        echo "Detected apt (Debian/Ubuntu). Installing curl..."
        sudo apt-get install -y zsh curl
elif command -v dnf > /dev/null; then
        echo "Detected dnf (Fedora/RHEL). Installing curl..."
        sudo dnf install -y zsh curl
elif command -v yum > /dev/null; then
        echo "Detected yum (Older Fedora/CentOS/RHEL). Installing curl..."
        sudo yum install -y zsh curl
elif command -v pacman > /dev/null; then
        echo "Detected pacman (Arch/Manjaro). Installing curl..."
        sudo pacman -Sy --noconfirm zsh curl
elif command -v zypper > /dev/null; then
        echo "Detected zypper (OpenSUSE). Installing curl..."
        sudo zypper install -y zsh curl
elif command -v apk > /dev/null; then
        echo "Detected apk (Alpine Linux). Installing curl..."
        sudo apk add zsh curl
else
        echo "Error: Package manager not supported or detected. Install zsh and curl manually."
        exit 1
fi

echo " "

if [ ! -e ~/Downloads/Hack.zip ]; then
	echo "Installing Hack Font" 
	curl https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip -o ~/Downloads/Hack.zip
	echo " "
fi

if [ ! -d ~/Downloads/hack_font ] && [ -e ~/Downloads/Hack.zip ]; then
	echo "Unzipping Hack.zip to hack_font dir"
	unzip ~/Downloads/Hack.zip -d ~/Downloads/hack_font
	echo " "
fi

if [ -d ~/Downloads/hack_font ]; then 
	echo "Copying font files into system"
	cp ~/Downloads/hack_font/*.ttf ~/.local/share/fonts/
	echo " "
fi

echo "Installing the font in the system"
fc-cache -fv
