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

# SETUP #
print_heading "Pre-setup: Ensure you're running Debian with Cinnamon DE!"
ask_confirmation "This script is designed for Debian with the Cinnamon Desktop Environment. Do you want to continue?"

# Install required packages
print_heading "Installing Required Packages..."
sudo apt update
sudo apt install -y git wget sddm timeshift

# CREATE SNAPSHOT #
print_heading "Creating Timeshift Snapshot..."
sudo timeshift --create --comments "Before Nordic Debian Customization"
snapshot_id=$(sudo timeshift --list | grep "Before Nordic Debian Customization" | awk '{print $1}')

# Check if snapshot was created successfully
if [ -n "$snapshot_id" ]; then
    print_success "Snapshot created successfully! If anything fails, you can restore it with:"
    echo -e "\033[1;33m    sudo timeshift --restore --snapshot $snapshot_id\033[0m"
else
    print_error "Failed to create snapshot. Exiting."
    exit 1
fi

# NORDIC DE #
print_heading "Setting up Nordic Theme..."
if [ ! -d "$HOME/.themes" ]; then
    print_info "Creating ~/.themes directory..."
    mkdir -p "$HOME/.themes"
else
    print_info "$HOME/.themes already exists."
fi

if [ ! -f "$HOME/.themes/Nordic.tar.xz" ]; then
    print_info "Downloading the Nordic theme..."
    wget -q -P "$HOME/.themes" https://github.com/EliverLara/Nordic/releases/download/v2.2.0/Nordic.tar.xz
else
    print_info "Nordic theme file already exists. Skipping download."
fi

print_info "Extracting Nordic theme..."
tar -xvJf "$HOME/.themes/Nordic.tar.xz" -C "$HOME/.themes"

print_success "Nordic theme setup complete!"

# PAPIRUS ICONS #
print_heading "Installing Papirus Icons..."
# Check if the repository already exists
if [ ! -f "/etc/apt/sources.list.d/papirus-ppa.list" ]; then
    print_info "Adding Papirus repository..."
    sudo sh -c "echo 'deb http://ppa.launchpad.net/papirus/papirus/ubuntu jammy main' > /etc/apt/sources.list.d/papirus-ppa.list"
else
    print_info "Papirus repository already exists. Skipping addition."
fi

# Check if the GPG key already exists
if [ ! -f "/etc/apt/trusted.gpg.d/papirus-ppa.asc" ]; then
    print_info "Downloading Papirus GPG key..."
    sudo wget -qO /etc/apt/trusted.gpg.d/papirus-ppa.asc 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x9461999446FAF0DF770BFC9AE58A9D36647CAE7F'
else
    print_info "Papirus GPG key already exists. Skipping download."
fi

sudo apt-get update -q
sudo apt-get install -y papirus-icon-theme

print_success "Papirus icons installed successfully!"

# SDDM Display Manager #
print_heading "Switching to SDDM Display Manager..."
# Check if lightdm is currently enabled
if systemctl is-active --quiet lightdm; then
    print_info "Disabling lightdm and enabling sddm..."
    sudo systemctl disable lightdm
    sudo systemctl enable sddm
else
    print_info "LightDM is not running, no need to disable."
fi

print_info "Cloning Nord SDDM theme from GitHub..."
if [ ! -d "$HOME/Downloads/nord-sddm" ]; then
    git clone https://github.com/nautilor/nord-sddm.git "$HOME/Downloads/nord-sddm"
else
    print_info "Nord SDDM theme already exists in $HOME/Downloads."
fi

print_info "Copying Nord theme to SDDM directory..."
sudo cp -R "$HOME/Downloads/nord-sddm/Nord" /usr/share/sddm/themes/

# Create and configure the sddm.conf file
print_info "Configuring SDDM to use the Nord theme..."
if [ ! -f "/etc/sddm.conf" ]; then
    sudo touch /etc/sddm.conf
fi
echo -e "[Theme]\nCurrent=Nord" | sudo tee /etc/sddm.conf > /dev/null

print_success "SDDM Display Manager set up with Nord theme!"

# GRUB #
print_heading "Setting up GRUB with Nord theme..."
if [ ! -d "$HOME/Downloads/grub2-nord-theme" ]; then
    git clone https://github.com/stevendejongnl/grub2-nord-theme.git "$HOME/Downloads/grub2-nord-theme"
else
    print_info "GRUB Nord theme already exists in $HOME/Downloads."
fi
sudo "$HOME/Downloads/grub2-nord-theme/install.sh"

print_success "GRUB theme installation complete!"

# Final user instructions
print_heading "Setup Complete!"
print_info "Please manually apply the following theme components:"
echo -e "\033[1;35m- Go to 'Themes' > 'Applications' and select 'Nordic'.\033[0m"
echo -e "\033[1;35m- Go to 'Themes' > 'Icons' and select 'Papirus-Dark'.\033[0m"
echo -e "\033[1;35m- Go to 'Themes' > 'Desktop' and select 'Nordic'.\033[0m"
print_info "After you are done..."
echo -e "\033[1;33mPlease reboot your system to apply all the changes.\033[0m"