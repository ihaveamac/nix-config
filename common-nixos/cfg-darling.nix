{ config, lib, pkgs, ... }:

{
  programs.darling = {
    enable = true;
    package = pkgs.darling.overrideAttrs (final: prev: {
      version = "unstable-2024-08-31";
      src = pkgs.fetchFromGitHub {
        owner = "darlinghq";
        repo = "darling";
        rev = "1eaee443fcdb072fd41857f9504816d980faac8f";
        fetchSubmodules = true;
        hash = "sha256-E8rXufQRU+UCyXTobRnJLkr/jkNXrqjLeR2qykAFdDE=";
      };
      # undo this: https://github.com/NixOS/nixpkgs/pull/340323
      # since the one in nixpkgs is old, maybe on purpose?
      patches = [];
    });
  };
}
