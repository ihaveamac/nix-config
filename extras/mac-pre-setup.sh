#!/bin/bash

# i could probably have this install nix as the first thing, and then depend on it for the rest of setup
# but meeeeeh

set -e

# bputil will get the current policy
# diskutil + sed will get the current booted apfs volume group id
# tail cuts off the header which breaks json parsing

# https://forums.developer.apple.com/forums/thread/114452
if [ -r /Library/Preferences/com.apple.TimeMachine.plist ]; then
	echo "Full Disk Access is granted"
else
	echo "You need to give Terminal \"Full Disk Access\"!"
	open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
	exit 1
fi
echo "Make sure to edit the username in flake.nix!!!!!! Waiting for enter."
read -s

echo "Checking boot policy..."
booted_apfs_vuid=`diskutil info / | sed -n 's/^ *APFS Volume Group: *//p'`
boot_policy_json=`sudo bputil -d --json -v $booted_apfs_vuid | tail -n +2`
current_security_level=`echo "$boot_policy_json" | sed -n 's/.*"security_mode" *: *"\(.*\)".*/\1/p'`
echo boot policy $current_security_level
if [ "$current_security_level" = "full" ]; then
	echo "Security level needs to be reduced!"
	exit 1
fi

if [ ! -f /Library/Apple/usr/share/rosetta/rosetta ]; then
	echo "Rosetta not installed! Doing that..."
	sudo softwareupdate --install-rosetta
fi
if xcode-select --install; then
	echo "Waiting for Command Line Tools to be installed. Press enter when done."
	read -s
else
	echo "Seems Command Line Tools are already installed."
fi

# brew install
my_arch=`uname -m`
if [ "$my_arch" == "arm64" ]; then
	brew_cmd=/opt/homebrew/bin/brew
else
	brew_cmd=/usr/local/bin/brew
fi
if [ ! -x $brew_cmd ]; then
	echo "Brew not found! Installing"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# special case -- save3ds_fuse and other fuse stuff may fail to build if this isn't installed
# nix-darwin installs brew packages only during activation, after nix derivations are built
$brew_cmd install --cask macfuse

# nix install
if [ ! -d /nix ]; then
	echo "Nix not found! Installing"
	curl -sSf -L https://install.lix.systems/lix | sh -s -- install
fi

script_path=$(realpath $(dirname "$0"))
echo "Done!!! Now:"
echo "  nix run -v -L nix-darwin -- switch -v -L --flake \"${script_path}#(flake name)\""
