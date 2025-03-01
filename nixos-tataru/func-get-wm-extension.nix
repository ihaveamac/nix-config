{ pkgs }:

{
  name,
  rev,
  hash,
  branch ? null,
  skin ? false,
}:
let
  mediawiki-info = builtins.fromJSON (builtins.readFile ./mediawiki-info.json);
  defaultBranch = mediawiki-info.defaultBranch;
  ext = pkgs.fetchFromGitHub {
    inherit rev hash;
    owner = "wikimedia";
    repo = "mediawiki-${if skin then "skin" else "extension"}-${name}";
    passthru = {
      branch = if branch == null then defaultBranch else branch;
      # this is kind of a hack
      src = ext;
      # this is also kind of a hack (prevent nix-update from updating the useless version)
      version = "0" + "0";
    };
  };
in
ext
