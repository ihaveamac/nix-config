{ config, lib, pkgs, me, r, inputs, modulesPath, ... }:

{
  imports = [
    (r.extras + /shared-nix-settings.nix)
    (r.common-nixos + /cfg-misc.nix)
    (r.common-nixos + /cfg-home-manager.nix)
    (r.common-nixos + /cfg-common-system-packages.nix)
    (r.common-nixos + /cfg-linux-kernel.nix)
    (r.common-nixos + /cfg-ssh.nix)
    (r.common-nixos + /cfg-nix-settings.nix)
    (r.common-nixos + /cfg-my-user.nix)
    (r.common-nixos + /cfg-podman.nix)
    (r.common-nixos + /cfg-shell-aliases.nix)
    (r.common-nixos + /cfg-sudo-config.nix)
    (r.common-nixos + /cfg-auto-optimise.nix)
    (r.common-nixos + /cfg-xdg.nix)
    (r.common-nixos + /cfg-neovim.nix)
    (r.common-nixos + /cfg-zsh.nix)
    ./hardware-configuration.nix
    ./networking.nix
    ./cfg-nginx.nix
    ./cfg-homebox.nix
    ./cfg-atticd.nix
    ./cfg-mediawiki.nix
    ./cfg-znc.nix
    ./cfg-discord-ghfilter.nix

    inputs.hax-nur.nixosModules.overlay
    inputs.lix-module.nixosModules.default
    "${modulesPath}/profiles/minimal.nix"
  ];

  home-manager.users.${me}.imports = [
    ./home.nix
    (r.common-home + /linux.nix)
    (r.common-home + /core.nix)
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
