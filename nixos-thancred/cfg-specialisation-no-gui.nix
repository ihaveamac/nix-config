{ config, lib, pkgs, ... }:

{
  specialisation.no-gui.configuration = {
    system.nixos.tags = [ "no-gui" ];
    services = {
      xserver.enable = lib.mkForce false;
      # remove nvidia from list
      xserver.videoDrivers = lib.mkForce [ ];
      displayManager.sddm.enable = lib.mkForce false;
      desktopManager.plasma6.enable = lib.mkForce false;
      flatpak.enable = lib.mkForce false;
      hardware.openrgb.enable = lib.mkForce false;
      getty.helpLine = "\n\nUse the command `nmcli connection up <network-name> --ask' to connect to a Wi-Fi network.";
    };

    hardware = {
      xpadneo.enable = lib.mkForce false;
      bluetooth.enable = lib.mkForce false;
      graphics.enable = lib.mkForce false;
    };

    programs = {
      steam.enable = lib.mkForce false;
      gamemode.enable = lib.mkForce false;
      partition-manager.enable = lib.mkForce false;
      kdeconnect.enable = lib.mkForce false;
      firefox.enable = lib.mkForce false;
      thunderbird.enable = lib.mkForce false;
    };

    virtualisation.vmware.host.enable = lib.mkForce false;
  };
}
