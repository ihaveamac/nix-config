{ config, lib, pkgs, ... }:

{
  programs = {
    man.enable = false;
    nix-index.enable = lib.mkForce false;
    zsh = {
      initExtra = ''
        ######################################################################
        # begin nixos-tataru/home.nix

        LOCALCOLOR=$'%{\e[1;32m%}'

        # end nixos-tataru/home.nix
      '';
    };
  };
}
