#!/bin/bash

# Install zsh and curl package
echo "Installing zsh and curl..."
echo " "

if command -v apt-get > /dev/null; then
	echo "Detected apt (Debian/Ubuntu). Installing zsh and curl..."
	sudo apt-get install -y zsh curl
elif command -v dnf > /dev/null; then
	echo "Detected dnf (Fedora/RHEL). Installing zsh and curl..."
	sudo dnf install -y zsh curl
elif command -v yum > /dev/null; then
	echo "Detected yum (Older Fedora/CentOS/RHEL). Installing zsh and curl..."
	sudo yum install -y zsh curl
elif command -v pacman > /dev/null; then
	echo "Detected pacman (Arch/Manjaro). Installing zsh and curl..."
	sudo pacman -Sy --noconfirm zsh curl
elif command -v zypper > /dev/null; then
	echo "Detected zypper (OpenSUSE). Installing zsh and curl..."
	sudo zypper install -y zsh curl
elif command -v apk > /dev/null; then
	echo "Detected apk (Alpine Linux). Installing zsh and curl..."
	sudo apk add zsh curl
else
	echo "Error: Package manager not supported or detected. Install zsh and curl manually."
	exit 1
fi

echo " "

if [ ! -e ~/.antigen.zsh ]; then
	echo "Getting antigen package manager for zsh..."
	curl -L git.io/antigen > ~/.antigen.zsh
	echo " "
fi
if [ ! -d  ~/.antigen ] && [ -e ~/.antigen.zsh ]; then
	echo "Installing antigen..."
	echo " "
	zsh ~/.antigen.zsh
fi


if [ ! -e ~/.zshrc ]; then
	echo "Creating zsh config..."
	echo " "
	cp zshrc ~/.zshrc
fi


if [ -e ~/.zshrc ]; then
	echo "Applying zsh config..."
	echo " "
	zsh ~/.zshrc
fi

if [ "$(echo $SHELL)" != "/bin/zsh" ]; then
	echo "Setting zsh as default shell..."
	chsh -s /bin/zsh
fi
