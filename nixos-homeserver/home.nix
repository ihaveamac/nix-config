{ config, lib, pkgs, r, ... }:

{
  imports = [
    (r.common-home + /core.nix)
    (r.common-home + /linux.nix)
    (r.common-home + /cfg-docker-aliases.nix)
  ];

  programs = {
    nix-index.enable = lib.mkForce false;
  };
}
