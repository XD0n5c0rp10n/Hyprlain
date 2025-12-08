#!/usr/bin/env bash
THISDIR=$(dirname "$(realpath "$0")")
GITSRC=${THISDIR}/src
source ${THISDIR}/../helper.sh

if ! helpersourced; then
	echo -e "${RED}ERROR! Couldn't source necessary helper script.${NOCOLR}"
	exit 1
fi

downdependencies "$GITSRC/pacpkgs.lst" "$GITSRC/aurpkgs.lst"

substitute "$BAKORDEL" "${HOME}/.config/albert/config" "${GITSRC}/config"
substitute "$BAKORDEL" "/usr/share/albert/widgetsboxmodel/themes/Hyprlain.qss" "${GITSRC}/Hyprlain.qss"

echo -e "${GREEN}Albert Hyprlain theme installed succesfully.${NOCOLR}"