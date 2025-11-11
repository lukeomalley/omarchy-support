#!/bin/bash

# Install script for Omarchy dotfiles
# Manages backing up existing configs and stowing new ones

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the dotfiles directory (parent of scripts directory)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo -e "${GREEN}======================================"
echo "Omarchy Dotfiles Installation"
echo -e "======================================${NC}"
echo ""

# Change to the dotfiles directory
cd "$DOTFILES_DIR"

# Function to install a package
install_package() {
    local package=$1
    echo -e "${YELLOW}📦 Installing package: $package${NC}"
    
    # Find all files that would be stowed
    local files_to_check=()
    while IFS= read -r file; do
        # Get relative path from package directory
        rel_path="${file#$package/}"
        target_path="$HOME/$rel_path"
        files_to_check+=("$target_path")
    done < <(find "$package" -type f 2>/dev/null || true)
    
    # Check if any target files exist and aren't already symlinks to our repo
    local needs_backup=false
    for target in "${files_to_check[@]}"; do
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            needs_backup=true
            break
        elif [ -L "$target" ]; then
            # Check if it already points to our dotfiles
            link_target=$(readlink "$target")
            if [[ "$link_target" == *"omarchy-dotfiles/$package"* ]]; then
                echo -e "   ${GREEN}✓${NC} Already stowed: $(basename $target)"
            else
                needs_backup=true
                break
            fi
        fi
    done
    
    # Backup existing files if needed
    if [ "$needs_backup" = true ]; then
        local backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"
        echo -e "   ${YELLOW}📋 Backing up existing files to: $backup_dir${NC}"
        mkdir -p "$backup_dir"
        
        for target in "${files_to_check[@]}"; do
            if [ -e "$target" ]; then
                local rel_to_home="${target#$HOME/}"
                local backup_path="$backup_dir/$rel_to_home"
                mkdir -p "$(dirname "$backup_path")"
                
                if [ -L "$target" ]; then
                    echo -e "   ${YELLOW}→${NC} Removing symlink: $rel_to_home"
                    rm "$target"
                else
                    echo -e "   ${YELLOW}→${NC} Backing up: $rel_to_home"
                    mv "$target" "$backup_path"
                fi
            fi
        done
    fi
    
    # Stow the package
    echo -e "   ${GREEN}🔗 Stowing $package...${NC}"
    if stow -v "$package" 2>&1 | grep -E "LINK|UNLINK"; then
        echo -e "   ${GREEN}✓${NC} Package $package installed successfully!"
    else
        echo -e "   ${GREEN}✓${NC} Package $package installed!"
    fi
    
    echo ""
}

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo -e "${RED}Error: stow is not installed${NC}"
    echo "Please install it with: sudo pacman -S stow"
    exit 1
fi

# List of packages to install
PACKAGES=("ghostty" "starship" "tmux")

# Install all packages
for package in "${PACKAGES[@]}"; do
    if [ -d "$package" ]; then
        install_package "$package"
    else
        echo -e "${YELLOW}Warning: $package package not found, skipping...${NC}"
    fi
done

echo -e "${GREEN}======================================"
echo "Installation Complete! 🎉"
echo -e "======================================${NC}"
echo ""
echo "Next steps:"
echo "  1. Restart ghostty to see your terminal changes"
echo "  2. Open a new shell or run 'source ~/.bashrc' to see starship changes"
echo "  3. For tmux: restart any running tmux sessions or run 'tmux source ~/.config/tmux/tmux.conf'"
echo "  4. Install tmux plugins: press 'Ctrl+Space + I' in tmux"
echo "  5. Your old configs are backed up in ~/.dotfiles-backup/"
echo "  6. Any changes to the dotfiles will now be reflected immediately!"
echo ""

