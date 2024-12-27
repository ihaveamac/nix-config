{ config, lib, pkgs, ... }:

{
  nix.settings.netrc-file = lib.mkForce "${config.home.homeDirectory}/.config/nix/netrc";
  #nix.package = pkgs.lix;

  systemd.user.systemctlPath = "/usr/bin/systemctl";

  programs.home-manager.enable = true;

  targets.genericLinux.enable = lib.strings.hasSuffix "linux" config.nixpkgs.system;
}
