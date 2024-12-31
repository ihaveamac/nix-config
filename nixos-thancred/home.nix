{ config, lib, pkgs, r, osConfig, ... }:

{
  imports = [
    (r.common-home + /cfg-docker-aliases.nix)
  ];

  programs = {
    nix-index.enable = lib.mkForce false;
  };

  services.lnshot.enable = true;
}
