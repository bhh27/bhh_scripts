#!/bin/bash


export BHH_ROOT=$HOME'/.local/share/bhh'

BHH_SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BHH_BINARIES=$BHH_ROOT'/bin'
BHH_RC='source '$BHH_ROOT'/default/bash/rc'
BHH_HYPR='source = '$BHH_ROOT'/default/hypr/hyprland.conf'
BHH_WAYBARSTYLE=$BHH_ROOT'/default/waybar/style.css'
BHH_BACKGROUNDS=$BHH_ROOT'/default/backgrounds'

BASHRC=$HOME'/.bashrc'
HYPRCONF=$HOME'/.config/hypr/hyprland.conf'
WAYBARSTYLE=$HOME'/.config/waybar/style.css'
THEME_TOKYOLED=$HOME'/.config/omarchy/themes/tokyoled'

sudo echo 'Installing bhh customisations'

#Check bhh folder exists, if not create it and parent structure
if ! [[ -d "$BHH_ROOT" ]]; then
    echo "Folder does not exist, creating it..."
    mkdir -p "$BHH_ROOT"
    echo "Folder created: $BHH_ROOT"
fi

#copy bhh files folder
echo "Copying bhh files to: $BHH_ROOT"
sudo cp -r $BHH_SETUP_DIR/bin $BHH_ROOT
sudo cp -r $BHH_SETUP_DIR/default $BHH_ROOT

#prepare bashrc
touch "$BASHRC"

if ! grep -Fxq "$BHH_RC" "$BASHRC"; then
    echo "$BHH_RC" >> "$BASHRC"
fi

source $BASHRC

#prepare hyprland
if ! grep -Fxq "$BHH_HYPR" "$HYPRCONF"; then
    echo "$BHH_HYPR" >> "$HYPRCONF"
fi

#prepare waybar
[[ -f $WAYBARSTYLE ]] && mv $WAYBARSTYLE $WAYBARSTYLE'.'$(date +"%Y%m%d_%H%M%S")'.bak'
cp $BHH_WAYBARSTYLE $WAYBARSTYLE

#theme install 
omarchy-theme-install https://github.com/Justin-De-Sio/omarchy-tokyoled-theme
[[ -d $THEME_TOKYOLED ]] && cp -r $BHH_BACKGROUNDS $THEME_TOKYOLED
[[ -f $THEME_TOKYOLED'/backgrounds/black.jpg' ]] && rm $THEME_TOKYOLED'/backgrounds/black.jpg'
omarchy-theme-next

#ensure all scripts are excuteable
if [[ -d "$BHH_BINARIES" ]]; then
    chmod +x "$BHH_BINARIES"/*
fi

#reload hyprland when done
hyprctl reload
