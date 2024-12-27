{ config, lib, pkgs, osConfig, ... }:

{
  imports = [
    ../common-home/cfg-docker-aliases.nix
  ];

  programs = {
    nix-index.enable = lib.mkForce false;
  };

  services.lnshot.enable = true;
}
