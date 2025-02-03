# nix-instantiate --eval --strict --json get-composer-ext-info.nix | jq
{ extname }:
let
  exts = import ./. { };
in
with exts.${extname};
{
  composerLock = toString composerLock;
  gitRepoUrl = src.gitRepoUrl;
}
