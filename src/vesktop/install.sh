#!/usr/bin/env bash
THISDIR=$(dirname "$(realpath "$0")")
GITSRC=${THISDIR}/src
source ${THISDIR}/../helper.sh

if ! helpersourced; then
	echo -e "${RED}ERROR! Couldn't source necessary helper script.${NOCOLR}"
	exit 1
fi

downdependencies "${GITSRC}/pacpkgs.lst" "${GITSRC}/aurpkgs.lst"

substitute "$BAKORDEL" "${HOME}/.config/vesktop/settings/settings.json" "${GITSRC}/settings.json"
substitute "$BAKORDEL" "${HOME}/.config/vesktop/themes/hyprlain.theme.css" "${GITSRC}/hyprlain.theme.css"

echo -e "${GREEN}Vesktop Hyprlain theme installed succesfully.${NOCOLR}"