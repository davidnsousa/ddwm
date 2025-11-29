# Arch Linux Post Installation Setup Script

ddwm installs the Pacman wrapper and AUR helper yay, updates the system, and sets up a basic desktop environment including dwm and dmenu.

[setup.sh](setup.sh) describes the installation procedure, the software included and pre-enabled services. The [configuration files](filesystem/home/user/) located in ~ and downstream control the entire DE. The keybinds are defined in the dwm configuration file [config.h](filesystem/home/user/dwm/config.h).

Note: DPI and font sizes are set for QHD screens.

### Usage

Requires Arch linux.

```
git clone --depth 1 https://github.com/davidnsousa/ddwm
cd ddwm
bash setup.sh
```
