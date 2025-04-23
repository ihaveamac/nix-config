{
  config,
  lib,
  pkgs,
  r,
  ...
}:

{
  imports = [
    (r.common-home + /linux.nix)
    (r.common-home + /core.nix)
  ];

  programs = {
    man.enable = false;
    nix-index.enable = lib.mkForce false;
    zsh = {
      initContent = ''
        ######################################################################
        # begin nixos-tataru/home.nix

        LOCALCOLOR=$'%{\e[1;32m%}'

        # end nixos-tataru/home.nix
      '';
    };
  };
}
