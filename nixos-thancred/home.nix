{ config, lib, pkgs, r, inputs, osConfig, ... }:

{
  imports = [
    (r.common-home + /core.nix)
    (r.common-home + /desktop.nix)
    (r.common-home + /linux.nix)
    (r.common-home + /cfg-docker-aliases.nix)
    inputs.hax-nur.hmModules.lnshot
  ];

  programs = {
    nix-index.enable = lib.mkForce false;
  };

  services.lnshot.enable = true;
}
