#!/bin/bash

# Function to display a heading
print_heading() {
    echo -e "\n===================================================="
    echo -e "$1"
    echo -e "====================================================\n"
}

# Function to display success messages
print_success() {
    echo -e "\033[1;32m[SUCCESS] $1\033[0m"
}

# Function to display info messages
print_info() {
    echo -e "\033[1;34m[INFO] $1\033[0m"
}

# Function to display error messages
print_error() {
    echo -e "\033[1;31m[ERROR] $1\033[0m"
}

# Function to display a confirmation prompt
ask_confirmation() {
    read -p "$1 (y/n): " -n 1 -r
    echo    # Move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Exiting script. User did not confirm."
        exit 1
    fi
}

# Install curl package
print_heading "Installing curl..."
echo " "

# Detect the package manager and install curl
if command -v apt-get > /dev/null; then
    print_info "Detected apt (Debian/Ubuntu). Installing curl..."
    sudo apt-get install -y zsh curl
elif command -v dnf > /dev/null; then
    print_info "Detected dnf (Fedora/RHEL). Installing curl..."
    sudo dnf install -y zsh curl
elif command -v yum > /dev/null; then
    print_info "Detected yum (Older Fedora/CentOS/RHEL). Installing curl..."
    sudo yum install -y zsh curl
elif command -v pacman > /dev/null; then
    print_info "Detected pacman (Arch/Manjaro). Installing curl..."
    sudo pacman -Sy --noconfirm zsh curl
elif command -v zypper > /dev/null; then
    print_info "Detected zypper (OpenSUSE). Installing curl..."
    sudo zypper install -y zsh curl
elif command -v apk > /dev/null; then
    print_info "Detected apk (Alpine Linux). Installing curl..."
    sudo apk add zsh curl
else
    print_error "Error: Package manager not supported or detected. Install zsh and curl manually."
    exit 1
fi

print_info "Curl package installed successfully!"
echo " "

# Check if Hack.zip is already downloaded
if [ ! -e ~/Downloads/Hack.zip ]; then
    print_info "Downloading Hack Font..."
    curl https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip -o ~/Downloads/Hack.zip
    echo " "
else
    print_info "Hack Font already downloaded. Skipping download."
fi

# Check if Hack.zip is unzipped, then unzip it
if [ ! -d ~/Downloads/hack_font ] && [ -e ~/Downloads/Hack.zip ]; then
    print_info "Unzipping Hack.zip to hack_font directory..."
    unzip ~/Downloads/Hack.zip -d ~/Downloads/hack_font
    echo " "
else
    print_info "Hack Font already unzipped. Skipping extraction."
fi

# Copy font files into the system
if [ -d ~/Downloads/hack_font ]; then 
    print_info "Copying font files into the system..."
    cp ~/Downloads/hack_font/*.ttf ~/.local/share/fonts/
    echo " "
else
    print_error "Error: Hack font directory not found."
    exit 1
fi

# Install the font in the system
print_info "Installing the font in the system..."
fc-cache -fv

print_success "Hack Font installation complete!"