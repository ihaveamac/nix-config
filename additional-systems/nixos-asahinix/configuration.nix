# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, me, ... }:

{
  imports = [
    ../../common-nixos/cfg-misc.nix
    ../../common-nixos/cfg-common-system-packages.nix
    ../../common-nixos/cfg-my-user.nix
    ../../common-nixos/cfg-plasma6.nix
    ../../common-nixos/cfg-time-and-i18n.nix
    ../../common-nixos/cfg-nix-homeserver-builder.nix
    ../../common-nixos/cfg-sudo-config.nix
    ../../common-nixos/cfg-shell-aliases.nix
    ../../common-nixos/cfg-firefox.nix
    ../../common-nixos/cfg-python-environment.nix
    ../../common-nixos/cfg-neovim.nix
    ../../common-nixos/cfg-zsh.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
    tmp.cleanOnBoot = true;
    # allow build for x86_64-linux architecture through emulation
    binfmt.emulatedSystems = [ "x86_64-linux" "i686-linux" "riscv64-linux" ];
  };

  networking = {
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    hostName = "asahinix";
  };

  services = {
    tailscale.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    smartmontools
  ];

  programs = {
    partition-manager.enable = true;
    traceroute.enable = true;
    gnupg.agent = {
      enable = true;
    };
    tmux.enable = true;
  };

  users.users.${me} = {
    extraGroups = [ "networkmanager" ];
    packages = (with pkgs; [
      firefox
      keepassxc
      telegram-desktop
      vesktop
    ]);
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}

