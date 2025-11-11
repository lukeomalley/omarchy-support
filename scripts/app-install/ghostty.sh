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

# Install ghostty from AUR via yay (Omarchy comes with yay pre-installed)
echo -e "${YELLOW}→${NC} Installing ghostty from AUR..."
yay -S --noconfirm ghostty

# Verify installation
if command -v ghostty &> /dev/null; then
    echo -e "${GREEN}✓${NC} Ghostty installed successfully!"
    ghostty --version
else
    echo -e "${RED}✗${NC} Ghostty installation failed"
    exit 1
fi

