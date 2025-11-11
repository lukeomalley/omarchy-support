#!/bin/bash

# Master Installation Script
# Installs all programs configured in the dotfiles repository

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get the app-install directory (where this script is)
INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}======================================"
echo "Omarchy Dotfiles - System Installation"
echo -e "======================================${NC}"
echo ""
echo "This will install all required programs:"
echo "  - Ghostty (terminal emulator)"
echo "  - Tmux (terminal multiplexer + TPM)"
echo ""
echo -e "${YELLOW}Press Enter to continue or Ctrl+C to cancel...${NC}"
read

# Check if install directory exists
if [ ! -d "$INSTALL_DIR" ]; then
    echo -e "${RED}Error: Install directory not found at $INSTALL_DIR${NC}"
    exit 1
fi

# Track installation results
FAILED_INSTALLS=()
SUCCESSFUL_INSTALLS=()

# Function to run an installation script
run_install() {
    local script_name=$1
    local script_path="$INSTALL_DIR/$script_name"
    
    if [ -f "$script_path" ]; then
        echo ""
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        if bash "$script_path"; then
            SUCCESSFUL_INSTALLS+=("$script_name")
        else
            FAILED_INSTALLS+=("$script_name")
            echo -e "${RED}Warning: $script_name failed but continuing...${NC}"
        fi
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    else
        echo -e "${YELLOW}Warning: $script_path not found, skipping...${NC}"
    fi
}

# Run all installation scripts
run_install "ghostty.sh"
run_install "tmux.sh"

# Summary
echo ""
echo -e "${BLUE}======================================"
echo "Installation Summary"
echo -e "======================================${NC}"
echo ""

if [ ${#SUCCESSFUL_INSTALLS[@]} -gt 0 ]; then
    echo -e "${GREEN}✓ Successful installations:${NC}"
    for install in "${SUCCESSFUL_INSTALLS[@]}"; do
        echo "  - ${install%.sh}"
    done
    echo ""
fi

if [ ${#FAILED_INSTALLS[@]} -gt 0 ]; then
    echo -e "${RED}✗ Failed installations:${NC}"
    for install in "${FAILED_INSTALLS[@]}"; do
        echo "  - ${install%.sh}"
    done
    echo ""
fi

echo "Next step: Run './scripts/install-dotfiles.sh' to stow your dotfiles!"
echo ""

