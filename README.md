# Omarchy Dotfiles

This repository contains my personal dotfiles for Omarchy, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Philosophy

Following Omarchy's recommendations:
- All user configurations live in `~/.config` (never modify `~/.local/share/omarchy`)
- Use stow to symlink configs from this repo to their proper locations
- Version control everything to maintain consistency across systems

## Structure

Each directory represents a "package" that can be independently managed with stow:

```
omarchy-dotfiles/
├── ghostty/          # Ghostty terminal configuration
│   └── .config/
│       └── ghostty/
│           └── config
├── hypr/             # Hyprland window manager configs
│   └── .config/
│       └── hypr/
├── waybar/           # Status bar configuration
│   └── .config/
│       └── waybar/
└── ...
```

## Prerequisites

Install GNU Stow:
```bash
sudo pacman -S stow
```

## Helper Scripts

This repository includes helper scripts to make management easier:

- **`./status.sh`** - Shows all packages and whether they're currently stowed
- **`./add-config.sh`** - Automates adding a new configuration to the repo
  ```bash
  ./add-config.sh hypr ~/.config/hypr/hyprland.conf
  ```

## Usage

### Installing Configurations

From this directory, use stow to create symlinks:

```bash
cd ~/omarchy-dotfiles

# Install a specific package
stow ghostty

# Install multiple packages
stow ghostty hypr waybar

# Install all packages
stow */
```

### Uninstalling Configurations

To remove symlinks (won't delete the actual files):

```bash
cd ~/omarchy-dotfiles

# Uninstall a package
stow -D ghostty

# Restow (useful after moving files)
stow -R ghostty
```

### Adding New Configurations

1. Create the package directory structure mirroring your home directory:
   ```bash
   mkdir -p packagename/.config/appname
   ```

2. Move your config file to the package:
   ```bash
   mv ~/.config/appname/config packagename/.config/appname/
   ```

3. Stow the package:
   ```bash
   stow packagename
   ```

4. Commit to git:
   ```bash
   git add .
   git commit -m "Add appname configuration"
   ```

## Current Packages

### ghostty
Ghostty terminal emulator configuration with:
- Gruvbox Dark Hard theme with custom background
- 90% opacity with blur effect
- Zsh shell integration
- Inconsolata Nerd Font Mono
- Optimized for ergonomics and aesthetics

## Version Control

This repository is tracked with git. To push to a remote:

```bash
git remote add origin <your-repo-url>
git push -u origin main
```

## Omarchy-Specific Notes

- Never modify files in `~/.local/share/omarchy` directly
- Override Omarchy defaults by editing configs in `~/.config/`
- After changing `~/.config/uwsm/default`, relaunch Hyprland
- After changing `~/.XCompose`, run `omarchy-restart-xcompose`
- Most configs can be edited via Omarchy menu (Super + Alt + Space) > Setup > Configs

## Resources

- [Omarchy Manual - Customization](https://learn.omacom.io/2/the-omarchy-manual)
- [GNU Stow Documentation](https://www.gnu.org/software/stow/manual/stow.html)
- [Managing Dotfiles with Stow](https://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html)

