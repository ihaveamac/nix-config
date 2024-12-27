{ config, lib, pkgs, ... }:

{
  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    displayManager = {
      defaultSession = "plasma";
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };

    # Enable the KDE Plasma Desktop Environment.
    desktopManager.plasma6.enable = true;
  };

  # enabling plasma6 enables this by default
  programs.kde-pim.enable = false;
}
