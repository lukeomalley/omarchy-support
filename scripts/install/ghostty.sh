#!/bin/bash

# Ghostty Terminal Installation Script
# Installs the Ghostty terminal emulator

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}📦 Installing Ghostty Terminal...${NC}"

# Check if ghostty is already installed
if command -v ghostty &> /dev/null; then
    echo -e "${GREEN}✓${NC} Ghostty is already installed"
    ghostty --version
    exit 0
fi

# Install ghostty from AUR
echo -e "${YELLOW}→${NC} Installing ghostty from AUR..."
if command -v yay &> /dev/null; then
    yay -S --noconfirm ghostty
elif command -v paru &> /dev/null; then
    paru -S --noconfirm ghostty
else
    echo -e "${RED}Error: No AUR helper found. Please install yay or paru first.${NC}"
    echo "To install yay:"
    echo "  git clone https://aur.archlinux.org/yay.git"
    echo "  cd yay"
    echo "  makepkg -si"
    exit 1
fi

# Verify installation
if command -v ghostty &> /dev/null; then
    echo -e "${GREEN}✓${NC} Ghostty installed successfully!"
    ghostty --version
else
    echo -e "${RED}✗${NC} Ghostty installation failed"
    exit 1
fi

