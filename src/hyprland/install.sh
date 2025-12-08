#!/usr/bin/env bash
THISDIR=$(dirname "$(realpath "$0")")
GITSRC=${THISDIR}/src
source ${THISDIR}/../helper.sh

if ! helpersourced; then
	echo -e "${RED}ERROR! Couldn't source necessary helper script.${NOCOLR}"
	exit 1
fi

downdependencies "${GITSRC}/pacpkgs.lst" "${GITSRC}/aurpkgs.lst"

echo -e "${GREEN}!!! CLOSE THE SHELL AFTER INSTALLING ZSH BY TYPING 'exit' !!!${NOCOLR}"; pause
handleold "$BAKORDEL" "${HOME}/.oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

IMGPATH="${HOME}/.config/assets/media/imgs/icons/favicon_32px.png"
WAYBARCONF="${GITSRC}/waybar/config.jsonc"
CONTENT=$(jq --arg IMGPATH "$IMGPATH" '.image.path = $IMGPATH' "$WAYBARCONF")
sudo echo "$CONTENT" > "$WAYBARCONF"

substitute "$BAKORDEL" "${HOME}/.config/wlogout/style.css" "${GITSRC}/wlogout/style.css"
substitute "$BAKORDEL" "${HOME}/.config/waybar/config.jsonc" "${GITSRC}/waybar/config.jsonc"
substitute "$BAKORDEL" "${HOME}/.config/waybar/power_menu.xml" "${GITSRC}/waybar/power_menu.xml"
substitute "$BAKORDEL" "${HOME}/.config/waybar/style.css" "${GITSRC}/waybar/style.css"
substitute "$BAKORDEL" "${HOME}/.config/hypr" "${GITSRC}/hypr"
substitute "$BAKORDEL" "${HOME}/.config/dunst/dunstrc" "${GITSRC}/dunst/dunstrc"
substitute "$BAKORDEL" "${HOME}/.config/assets" "${GITSRC}/assets"

substitute "$BAKORDEL" "${HOME}/.config/neofetch/config.conf" "${GITSRC}/neofetch/config.conf"
substitute "$BAKORDEL" "${HOME}/.config/neofetch/logo" "${GITSRC}/neofetch/logo"

substitute "$BAKORDEL" "${HOME}/.config/kitty/kitty.conf" "${GITSRC}/kitty/kitty.conf"
substitute "$BAKORDEL" "${HOME}/.config/kitty/current-theme.conf" "${GITSRC}/kitty/current-theme.conf"
substitute "$BAKORDEL" "${HOME}/.config/kitty/themes/hyprlain.conf" "${GITSRC}/kitty/themes/hyprlain.conf"
substitute "$BAKORDEL" "${HOME}/.config/kitty/themes/hyprlain.conf-colors" "${GITSRC}/kitty/themes/hyprlain-colors.conf"

sudo cat "${GITSRC}/.profile" >> "${HOME}/.profile"
DOTPROFILE_SHLINE="[[ -f ~/.profile ]] && . ~/.profile"
sudo echo "$DOTPROFILE_SHLINE" >> "${HOME}/.bashrc"
sudo echo "$DOTPROFILE_SHLINE" >> "${HOME}/.zshrc"

echo -e "${GREEN}Hyprland Hyprlain theme installed succesfully.${NOCOLR}"