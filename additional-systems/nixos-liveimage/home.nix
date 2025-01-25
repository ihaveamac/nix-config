{ config, lib, pkgs, r, ... }:

{
  imports = [
    (r.common-home + /cfg-neovim.nix)
    (r.common-home + /linux.nix)
    (r.common-home + /core.nix)
  ];
  programs.nix-index.enable = lib.mkForce false;
}
