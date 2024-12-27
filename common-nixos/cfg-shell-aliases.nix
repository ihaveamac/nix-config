{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "nrvl" ''
      exec ${config.system.build.nixos-rebuild}/bin/nixos-rebuild -v -L "$@"
    '')
  ];
}
