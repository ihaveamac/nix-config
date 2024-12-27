{ config, lib, pkgs, my-inputs, ... }:

{
  imports = [
    ./core.nix
  ];

  programs = {
    ssh.enable = lib.mkForce false;
    git.enable = lib.mkForce false;
  };
}
