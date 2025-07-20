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

# Install zsh and curl package
print_heading "Installing zsh and curl..."
echo " "

# Check for apt, dnf, yum, pacman, zypper, or apk package manager
if command -v apt-get > /dev/null; then
    print_info "Detected apt (Debian/Ubuntu). Installing zsh and curl..."
    sudo apt-get install -y zsh curl
elif command -v dnf > /dev/null; then
    print_info "Detected dnf (Fedora/RHEL). Installing zsh and curl..."
    sudo dnf install -y zsh curl
elif command -v yum > /dev/null; then
    print_info "Detected yum (Older Fedora/CentOS/RHEL). Installing zsh and curl..."
    sudo yum install -y zsh curl
elif command -v pacman > /dev/null; then
    print_info "Detected pacman (Arch/Manjaro). Installing zsh and curl..."
    sudo pacman -Sy --noconfirm zsh curl
elif command -v zypper > /dev/null; then
    print_info "Detected zypper (OpenSUSE). Installing zsh and curl..."
    sudo zypper install -y zsh curl
elif command -v apk > /dev/null; then
    print_info "Detected apk (Alpine Linux). Installing zsh and curl..."
    sudo apk add zsh curl
else
    print_error "Error: Package manager not supported or detected. Install zsh and curl manually."
    exit 1
fi

print_info "Packages installed successfully!"
echo " "

# Check if antigen is already installed
if [ ! -e ~/.antigen.zsh ]; then
    print_info "Getting antigen package manager for zsh..."
    curl -L git.io/antigen > ~/.antigen.zsh
    echo " "
else
    print_info "Antigen package manager already installed."
fi

# Check if antigen directory exists and install antigen
if [ ! -d ~/.antigen ] && [ -e ~/.antigen.zsh ]; then
    print_info "Installing antigen..."
    echo " "
    zsh ~/.antigen.zsh
else
    print_info "Antigen directory already exists or antigen is already installed."
fi

# Check if .zshrc exists, then copy the default one
if [ ! -e ~/.zshrc ]; then
    print_info "Creating zsh config..."
    echo " "
    cp zshrc ~/.zshrc
else
    print_info ".zshrc already exists. Skipping creation."
fi

# Apply zsh config if .zshrc exists
if [ -e ~/.zshrc ]; then
    print_info "Applying zsh config..."
    echo " "
    zsh ~/.zshrc
else
    print_error "Error: ~/.zshrc not found."
fi

# Check if zsh is already the default shell
if [ "$(echo $SHELL)" != "/bin/zsh" ]; then
    print_info "Setting zsh as default shell..."
    chsh -s /bin/zsh
else
    print_info "Zsh is already set as the default shell."
fi

print_success "Zsh setup complete!"