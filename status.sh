#!/bin/bash

# Shows the status of all packages in the dotfiles repository
# Usage: ./status.sh

echo "📦 Omarchy Dotfiles Repository Status"
echo "======================================"
echo ""

# Find all package directories (ones that contain .config or are top-level configs)
for dir in */; do
    dir="${dir%/}"  # Remove trailing slash
    
    # Skip .git directory
    if [ "$dir" = ".git" ]; then
        continue
    fi
    
    echo "📁 Package: $dir"
    
    # Count config files in this package
    file_count=$(find "$dir" -type f | wc -l)
    echo "   Files: $file_count"
    
    # Check if any files are symlinked (indicating it's stowed)
    is_stowed=false
    while IFS= read -r file; do
        # Get relative path from package directory
        rel_path="${file#$dir/}"
        target_path="$HOME/$rel_path"
        
        if [ -L "$target_path" ]; then
            # Check if it points to our dotfiles repo
            link_target=$(readlink "$target_path")
            if [[ "$link_target" == *"omarchy-dotfiles/$dir"* ]] || [[ "$link_target" == *"$dir"* ]]; then
                is_stowed=true
                break
            fi
        fi
    done < <(find "$dir" -type f)
    
    if [ "$is_stowed" = true ]; then
        echo "   Status: ✅ STOWED (active)"
    else
        echo "   Status: ⚠️  NOT STOWED (run: stow $dir)"
    fi
    
    echo ""
done

echo "======================================"
echo "Git status:"
git status --short

echo ""
echo "To stow a package: stow <package-name>"
echo "To unstow: stow -D <package-name>"
echo "To restow: stow -R <package-name>"

