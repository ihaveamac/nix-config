{ config, lib, pkgs, ... }:

{
  programs.nix-index.enable = lib.mkForce false;
}
