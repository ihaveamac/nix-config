{ config, lib, pkgs, me, modulesPath, ... }:

{
  imports = [
    ../common-nixos/cfg-misc.nix
    ../common-nixos/cfg-common-system-packages.nix
    ../common-nixos/cfg-linux-kernel.nix
    ../common-nixos/cfg-my-user.nix
    ../common-nixos/cfg-podman.nix
    ../common-nixos/cfg-shell-aliases.nix
    ../common-nixos/cfg-sudo-config.nix
    ../common-nixos/cfg-auto-optimise.nix
    ../common-nixos/cfg-xdg.nix
    ../common-nixos/cfg-neovim.nix
    ../common-nixos/cfg-zsh.nix
    ./cfg-nginx.nix
    ./cfg-homebox.nix
    ./cfg-atticd.nix
    ./cfg-mediawiki.nix
    ./cfg-znc.nix
    ./cfg-discord-ghfilter.nix

    "${modulesPath}/profiles/minimal.nix"
  ];

  boot = {
    tmp.cleanOnBoot = true;
    # normally disabled by minimal.nix
    enableContainers = lib.mkForce true;
  };

  zramSwap.enable = true;

  networking = {
    domain = "tataru.ihaveahax.net";
    hostName = "tataru";
    firewall.allowedTCPPorts = [
      80
      443
    ];
    # https://wiki.nixos.org/wiki/NixOS_Containers
    nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "ens3";
      # Lazy IPv6 connectivity for the container
      enableIPv6 = true;
    };
  };


  services = {
    tailscale.enable = true;
    do-agent.enable = true;
    openssh.settings = {
      X11Forwarding = lib.mkForce false;
      PasswordAuthentication = false;
    };
  };

  hax.packages.enableExtra = false;

  environment.systemPackages = with pkgs; [
  ];

  programs = {
    zsh = {
      shellInit = ''
        LOCALCOLOR=$'%{\e[1;32m%}'
      '';
    };
    tmux.enable = true;
  };

  nix.gc = {
    automatic = true;
    options = "--delete-old";
    dates = "09:00";
  };

  users.users = {
    luigoalma = {
      description = "luigoalma";
      isNormalUser = true;
      uid = 1001;
      linger = true;
      shell = pkgs.bashInteractive;
    };
  };

  system.stateVersion = "24.05";
}
