#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq phpPackages.composer

set -ex

ext=$1

composerLock=$(nix eval --impure --expr "with import ./. {}; $ext.composerLock")
src=$(nix eval --impure --raw --expr "with import ./. {}; $ext.src.outPath")

tmpdir=$(mktemp -d --suffix=composer-lock-updater)
cd $tmpdir
cp --no-preserve=mode -r $src ./$ext
cd $ext
composer update --no-dev --no-install
cp composer.lock $composerLock
cd /tmp
rm -r $tmpdir
