# Omarchy Support

This repository contains my personal dotfiles and supporting shell scripts for configuring and setting up an Omarchy system to my liking. Dotfiles are managed with [GNU Stow](https://www.gnu.org/software/stow/), and the included scripts automate program installation, configuration management, and system setup.

## Philosophy

Following Omarchy's recommendations:
- All user configurations live in `~/.config` (never modify `~/.local/share/omarchy`)
- Use stow to symlink configs from this repo to their proper locations
- Automate setup with shell scripts for reproducibility
- Version control everything to maintain consistency across systems

## Structure

The repository contains both dotfile packages and helper scripts:

```
omarchy-support/
├── ghostty/          # Ghostty terminal configuration
│   └── .config/
│       └── ghostty/
│           └── config
├── omarchy-overrides/  # Hyprland configuration overrides
│   └── .config/
│       └── omarchy-overrides/
│           └── omarchy-overrides.conf
├── starship/         # Starship prompt configuration
│   └── .config/
│       └── starship.toml
├── tmux/             # Tmux configuration
│   └── .config/
│       └── tmux/
│           └── tmux.conf
└── scripts/          # Helper scripts for automation
    ├── install-dotfiles.sh    # Stow all dotfiles
    ├── status.sh              # Show stow status
    ├── add-config.sh          # Add new configs
    └── app-install/           # Program installation scripts
        ├── install-all.sh
        ├── stow.sh
        ├── ghostty.sh
        ├── tmux.sh
```

Each top-level directory (except `scripts/`) represents a "package" that can be independently managed with stow.

## Installation

### Prerequisites

> **Note:** This setup is designed for Omarchy, which comes with `yay` pre-installed.

### Quick Setup

**1. Install Programs** - Installs GNU Stow, Ghostty, and Tmux + TPM:
```bash
./scripts/app-install/install-all.sh
```

**2. Link Configurations** - Creates symlinks with stow (backs up existing configs):
```bash
./scripts/install-dotfiles.sh
```

**3. Apply Changes** - Restart terminals and start tmux to install plugins (`Ctrl+Space + I`)

### Programs Installed

The `install-all.sh` script automatically installs:

| Program | Source | Description |
|---------|--------|-------------|
| **GNU Stow** | Official repos (via yay) | Symlink manager for dotfiles |
| **Ghostty** | AUR (via yay) | Fast, feature-rich terminal emulator |
| **Tmux** | Official repos (via yay) | Terminal multiplexer for managing multiple sessions |
| **TPM** | GitHub | Tmux Plugin Manager (auto-cloned to `~/.tmux/plugins/tpm`) |

**Individual Installation:**
```bash
./scripts/app-install/stow.sh       # Install just Stow
./scripts/app-install/ghostty.sh    # Install just Ghostty
./scripts/app-install/tmux.sh       # Install just Tmux + TPM
```

## Helper Scripts

All helper scripts are located in the `scripts/` directory:

### Configuration Management
- **`./scripts/install-dotfiles.sh`** - Stow dotfiles (create symlinks)
- **`./scripts/status.sh`** - Shows all packages and whether they're currently stowed
- **`./scripts/add-config.sh`** - Automates adding a new configuration to the repo
  ```bash
  ./scripts/add-config.sh hypr ~/.config/hypr/hyprland.conf
  ```

### Program Installation
- **`./scripts/app-install/install-all.sh`** - Install all programs at once
- **`./scripts/app-install/stow.sh`** - Install GNU Stow
- **`./scripts/app-install/ghostty.sh`** - Install Ghostty terminal
- **`./scripts/app-install/tmux.sh`** - Install Tmux + TPM
- **`./scripts/app-install/wtype.sh`** - Install wtype (Wayland keyboard simulator)

## Usage

### Installing Configurations

From this directory, use stow to create symlinks:

```bash
cd ~/omarchy-support

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
cd ~/omarchy-support

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

## Tmux Plugin Installation

TPM (Tmux Plugin Manager) is automatically installed when you run `./scripts/install-all.sh` or `./scripts/install/tmux.sh`.

To install the tmux plugins:

```bash
# Start tmux
tmux

# Install plugins by pressing: Ctrl+Space + I (capital i)
```

## Omarchy Overrides

Custom Hyprland configuration overrides that extend or modify Omarchy's default settings without touching the base configuration in `~/.local/share/omarchy`.

**Usage:**
1. Stow the package: `stow omarchy-overrides`
2. Add to your Hyprland config (`~/.config/hypr/hyprland.conf`):
   ```ini
   source = ~/.config/omarchy-overrides/omarchy-overrides.conf
   ```
3. Reload Hyprland: `Super + Shift + R` or restart Hyprland

This approach keeps your customizations separate and version-controlled while respecting Omarchy's architecture.

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

