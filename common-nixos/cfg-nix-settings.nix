{
  config,
  lib,
  pkgs,
  me,
  inputs,
  ...
}:

let
  nixpkgs-config-local = import ../extras/nixpkgs-config-local.nix { inherit pkgs inputs; };
in
{
  # seems nixpkgs already sets NIXPKGS_CONFIG to this path
  environment = {
    etc."nix/nixpkgs-config.nix".text = nixpkgs-config-local;
  };

  nix.settings = {
    # needed for cachix and linux-builder
    # root is assumed to be here
    trusted-users = [ "${me}" ];
  };
}
