#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq phpPackages.composer nix-update

ext=$1
if [ -z "$ext" ]; then
	echo "I need an extension"
	exit 1
fi

set -ex
curdir=$PWD

details=$(nix-instantiate --eval --strict --json get-composer-ext-info.nix --argstr extname $ext)
echo $details | jq

composerLock=$(echo $details | jq -r .composerLock)
gitRepoUrl=$(echo $details | jq -r .gitRepoUrl)

tmpdir=$(mktemp -d --suffix=composer-lock-updater)
cd $tmpdir
git clone --recursive --depth 1 "$gitRepoUrl" $ext
cd $ext
composer update --no-dev --no-install
cp composer.lock $composerLock
rm -rf $tmpdir
cd $curdir
nix-update --version=branch=master $ext
