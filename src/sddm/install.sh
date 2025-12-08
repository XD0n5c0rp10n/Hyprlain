#!/usr/bin/env bash
THISDIR=$(dirname "$(realpath "$0")")
GITSRC="${THISDIR}/src"
source "${THISDIR}/../helper.sh"

if ! helpersourced; then
	echo -e "${RED}ERROR! Couldn't source necessary helper script.${NOCOLOR}"
	exit 1
fi

downdependencies "${GITSRC}/pacpkgs.lst" "${GITSRC}/aurpkgs.lst"

substitute "$BAKORDEL" "/etc/sddm.conf" "${GITSRC}/sddm.conf"
substitute "$BAKORDEL" "/usr/share/sddm/themes/Hyprlain" "${GITSRC}/Hyprlain"

echo -e "${GREEN}SDDM Hyprlain theme installed successfully. Test with the following command:"
echo -e "sddm-greeter --test-mode --theme /usr/share/sddm/themes/Hyprlain${NOCOLOR}"