#!/bin/env bash
# set -euxo pipefail

function confirmnonroot() {
	if [ "$EUID" -eq 0 ]; then
			echo "Don't run the script as root! Aborting!"
			exit 1
	fi
}

function confirmonline() {
	if ! ping -c 1 google.com &> /dev/null; then
		echo "System is offline! Aborting!"
		exit 1
	fi
}

function getsudo() {
	if ! command -v sudo &> /dev/null; then
		su -c "pacman -Sy --needed sudo" root
	fi
	sudo echo
}

function getyay() {
	if ! command -v yay &> /dev/null; then
		sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
	fi
}

function pause() {
	echo "Press to continue..."; read
}

BAKORDEL="backup"
if ! [ $# -eq 0 ] && ! [ -z $1 ]; then
	case "$1" in
		"--no-preserve")
			echo "This option will delete all your previous configurations."
			echo "It may also risk affecting other associated files."
			read -p "Are you sure you want to proceed? [y/N]: " yn
			case $yn in
				[Yy]*)
					RES=0
					;;
				[Nn]*)
					RES=1
					;;
				*)
					RES=1
					;;
			esac
			if [ $RES == 0 ]; then
				BAKORDEL="--no-preserve"
				echo "Proceeding by deletion."
			elif [ $RES == 1 ]; then
				echo "Aborting."
				exit 0
			fi
		;;

		"backup");;

		*)
			echo "install.sh: unrecognized option '$1'"
			echo
			echo "Usage: install.sh [OPTION]"
			echo "Options:"
			echo "  --no-preserve	Replace old files by deleting them. [DANGEROUS]"
		;;
	esac
fi

function ynprompt () {
	while true; do
		read -p "$* [Y/n]: " yn
		case $yn in
			[Yy]*)
				return 0
				;;
			[Nn]*)
				return 1
				;;
			*)
				return 0
				;;
		esac
	done
}

function handleold () {
	ACTOPTION=$1
	DIRFILE=$2

	case "$ACTOPTION" in
		"--no-preserve")
			sudo rm -r $DIRFILE || true
			;;

		"backup")
			sudo rm -r $DIRFILE.hyprlainbak || true
			sudo mv $DIRFILE $DIRFILE.hyprlainbak || true
			;;

		*)
			echo "Unrecognized argument \"$1\" passed to handleold function."
			exit 254
		;;
	esac

	sudo mkdir -p $(dirname "$DIRFILE")
}

function substitute () {
	ACTOPTION=$1
	DIRFILE=$2
	GITFILE=$3

	handleold "$ACTOPTION" "$DIRFILE"
	sudo cp -r $GITFILE $DIRFILE
}

function downdependencies () {
	PACPKGS=$1
	AURPKGS=$2

	sudo pacman -Syu
	while read -r pkg; do
		[[ -z "$pkg" ]] && continue
		( sudo pacman -S --needed --noconfirm "$pkg" || echo "ERROR! Skipping PACMAN package: $pkg" ) || true
	done < "$PACPKGS"

	yay -Syu
	while read -r pkg; do
		[[ -z "$pkg" ]] && continue
		( yay -S --needed --noconfirm "$pkg" || echo "ERROR! Skipping AUR package: $pkg" ) || true
	done < "$AURPKGS"
}

confirmnonroot
confirmonline
getsudo
getyay
