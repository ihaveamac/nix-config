{ config, lib, pkgs, me, r, my-inputs, ... }:

{
  imports = [
    (r.common-nixos + /cfg-misc.nix)
    (r.common-nixos + /cfg-common-system-packages.nix)
    (r.extras + /shared-nix-settings.nix)
    (r.common-nixos + /cfg-linux-kernel.nix)
    (r.common-nixos + /cfg-my-user.nix)
    (r.common-nixos + /cfg-docker.nix)
    (r.common-nixos + /cfg-ssh.nix)
    (r.common-nixos + /cfg-nix-settings.nix)
    (r.common-nixos + /cfg-plasma6.nix)
    (r.common-nixos + /cfg-time-and-i18n.nix)
    (r.common-nixos + /cfg-sound.nix)
    (r.common-nixos + /cfg-nix-homeserver-builder.nix)
    (r.common-nixos + /cfg-sudo-config.nix)
    (r.common-nixos + /cfg-avahi.nix)
    (r.common-nixos + /cfg-shell-aliases.nix)
    (r.common-nixos + /cfg-firefox.nix)
    (r.common-nixos + /cfg-python-environment.nix)
    (r.common-nixos + /cfg-auto-optimise.nix)
    (r.common-nixos + /cfg-xdg.nix)
    (r.common-nixos + /cfg-neovim.nix)
    (r.common-nixos + /cfg-zsh.nix)
    (r.root + /nixos-thancred/cfg-java.nix)
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_testing;

  networking.hostName = "imacbooknix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  services.xserver.xkb.variant = lib.mkForce "mac";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${me} = {
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      vesktop
      discord
      telegram-desktop
      vlc
      prismlauncher
      keepassxc
    ];
  };

  environment.systemPackages = with pkgs; [
  ];

  environment.sessionVariables = {
    # should work now as of 130
    MOZ_ENABLE_WAYLAND = 1;
  };

  programs = {
    partition-manager.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    tmux.enable = true;
  };

  services = {
    tailscale.enable = true;
  };

  networking.firewall.allowedTCPPorts = [ 8000 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  system.stateVersion = "24.11"; # Did you read the comment?

}
