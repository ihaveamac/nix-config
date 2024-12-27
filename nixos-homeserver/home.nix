{ config, lib, pkgs, ... }:

{
  imports = [
    ../common-home/cfg-docker-aliases.nix
  ];

  programs = {
    nix-index.enable = lib.mkForce false;
  };
}
