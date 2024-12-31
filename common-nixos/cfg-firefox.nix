{ config, lib, pkgs, r, ... }:

# https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265

{
  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = with pkgs; [
      # note: plasma6 adds itself here
      keepassxc
    ];
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
    policies = import (r.extras + /firefox-policies.nix);
    package = pkgs.firefox-esr-128;
  };
}
