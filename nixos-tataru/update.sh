#!/usr/bin/env nix-shell
#!nix-shell -i bash -p python3 python3Packages.requests nix-update
python3 update-extensions.py
