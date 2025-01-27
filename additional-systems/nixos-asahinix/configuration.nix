# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  me,
  r,
  inputs,
  ...
}:

{
  imports = [
    (r.extras + /shared-nix-settings.nix)
    (r.common-nixos + /cfg-misc.nix)
    (r.common-nixos + /cfg-common-system-packages.nix)
    (r.common-nixos + /cfg-ssh.nix)
    (r.common-nixos + /cfg-nix-settings.nix)
    (r.common-nixos + /cfg-home-manager.nix)
    (r.common-nixos + /cfg-my-user.nix)
    (r.common-nixos + /cfg-plasma6.nix)
    (r.common-nixos + /cfg-time-and-i18n.nix)
    (r.common-nixos + /cfg-nix-homeserver-builder.nix)
    (r.common-nixos + /cfg-sudo-config.nix)
    (r.common-nixos + /cfg-shell-aliases.nix)
    (r.common-nixos + /cfg-firefox.nix)
    (r.common-nixos + /cfg-python-environment.nix)
    (r.common-nixos + /cfg-neovim.nix)
    (r.common-nixos + /cfg-zsh.nix)
    ./hardware-configuration.nix
    inputs.lix-module.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
  ];

  home-manager.users.${me}.imports = [
    ./home.nix
    (r.common-home + /linux.nix)
    (r.common-home + /desktop.nix)
    (r.common-home + /core.nix)
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
    tmp.cleanOnBoot = true;
    # allow build for x86_64-linux architecture through emulation
    binfmt.emulatedSystems = [
      "x86_64-linux"
      "i686-linux"
      "riscv64-linux"
    ];
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

  hardware.asahi = {
    enable = true;
    useExperimentalGPUDriver = true;
    setupAsahiSound = true;
  };

  #boot.kernelParams = [ "apple_dcp.show_notch=1" ];

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
    packages = (
      with pkgs;
      [
        firefox
        keepassxc
        telegram-desktop
        vesktop
      ]
    );
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
