#!/bin/bash

# Helper script to add new configurations to your dotfiles repository
# Usage: ./add-config.sh <package-name> <config-path>
# Example: ./add-config.sh hypr ~/.config/hypr/hyprland.conf

set -e

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <package-name> <config-path>"
    echo ""
    echo "Examples:"
    echo "  $0 hypr ~/.config/hypr/hyprland.conf"
    echo "  $0 waybar ~/.config/waybar"
    echo "  $0 bash ~/.bashrc"
    exit 1
fi

PACKAGE_NAME="$1"
CONFIG_PATH="$2"

# Expand tilde to home directory
CONFIG_PATH="${CONFIG_PATH/#\~/$HOME}"

# Check if config exists
if [ ! -e "$CONFIG_PATH" ]; then
    echo "Error: $CONFIG_PATH does not exist"
    exit 1
fi

# Get the relative path from home directory
REL_PATH="${CONFIG_PATH#$HOME/}"

# If the path didn't change, it means it wasn't under home directory
if [ "$REL_PATH" = "$CONFIG_PATH" ]; then
    echo "Error: Config must be under your home directory"
    exit 1
fi

# Create the package directory structure
DEST_DIR="$PACKAGE_NAME/$(dirname "$REL_PATH")"
mkdir -p "$DEST_DIR"

echo "📦 Adding $CONFIG_PATH to package '$PACKAGE_NAME'..."

# Check if it's a directory or file
if [ -d "$CONFIG_PATH" ]; then
    # It's a directory
    echo "📁 Copying directory..."
    cp -r "$CONFIG_PATH" "$DEST_DIR/"
    echo "🗑️  Removing original directory..."
    rm -rf "$CONFIG_PATH"
else
    # It's a file
    echo "📄 Copying file..."
    cp "$CONFIG_PATH" "$DEST_DIR/"
    echo "🗑️  Removing original file..."
    rm "$CONFIG_PATH"
fi

echo "🔗 Stowing package '$PACKAGE_NAME'..."
stow -v "$PACKAGE_NAME"

echo "✅ Done! Configuration added successfully."
echo ""
echo "Next steps:"
echo "  git add $PACKAGE_NAME"
echo "  git commit -m \"Add $PACKAGE_NAME configuration\""

