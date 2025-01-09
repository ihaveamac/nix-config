{ config, lib, pkgs, me, r, inputs, ... }:

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
    (r.common-nixos + /cfg-pc-boot.nix)
    (r.common-nixos + /cfg-docker.nix)
    (r.common-nixos + /cfg-time-and-i18n.nix)
    (r.common-nixos + /cfg-disable-sleep.nix)
    (r.common-nixos + /cfg-sudo-config.nix)
    (r.common-nixos + /cfg-zfs.nix)
    (r.common-nixos + /cfg-avahi.nix)
    (r.common-nixos + /cfg-shell-aliases.nix)
    (r.common-nixos + /cfg-libvirt.nix)
    (r.common-nixos + /cfg-python-environment.nix)
    (r.common-nixos + /cfg-auto-optimise.nix)
    (r.common-nixos + /cfg-xdg.nix)
    (r.common-nixos + /cfg-neovim.nix)
    (r.common-nixos + /cfg-zsh.nix)
    (r.common-nixos + /cfg-syncthing.nix)
    ./hardware-configuration.nix
    ./cfg-nextcloud.nix
    ./cfg-postgres.nix
    ./cfg-jellyfin.nix
    ./cfg-samba.nix
    ./cfg-discord-rolebot.nix
    ./cfg-discord-red-bot.nix
    ./cfg-discord-modmail-hax.nix
    ./cfg-srcds.nix

    inputs.hax-nur.nixosModules.overlay
    inputs.lix-module.nixosModules.default
    inputs.sops-nix.nixosModules.sops
  ];

  boot.loader.grub = {
    extraFiles."efi/netbootxyz/netboot.xyz.efi" = "${pkgs.netbootxyz-efi}";
    extraEntries = ''
      menuentry "netboot.xyz" {
        chainloader /efi/netbootxyz/netboot.xyz.efi
      }
    '';
  };

  boot.supportedFilesystems.xfs = true;

  networking = {
    networkmanager.enable = true;
    hostId = "422f2495";
    hostName = "homeserver"; # Define your hostname.
    firewall = {
      allowedTCPPorts = [
        8000  # Python http.server
      ];
    };
    # https://wiki.nixos.org/wiki/NixOS_Containers
    nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "eno1";
      # Lazy IPv6 connectivity for the container
      enableIPv6 = true;
    };
  };

  services = {
    tailscale.enable = true;
    avahi.publish = {
      enable = true;
      userServices = true;
      addresses = true;
    };
    syncthing = {
      guiAddress = "0.0.0.0:8384";
    };
  };

  environment.systemPackages = with pkgs; [
    ffmpeg_7-full
    steamcmd
    sops
  ];

  programs = {
    zsh = {
      shellInit = ''
        LOCALCOLOR=$'%{\e[1;30m%}'
      '';
    };
    # mainly used for steam game servers
    steam = {
      enable = true;
      dedicatedServer.openFirewall = true;
      extraPackages = with pkgs; [ pkgsi686Linux.ncurses5 ];
    };
    tmux.enable = true;
    traceroute.enable = true;
  };

  virtualisation = {
    docker = {
      storageDriver = lib.mkForce "zfs";
    };
  };

  users = {
    mutableUsers = false;

    users = {
      ${me} = {
        extraGroups = [ "networkmanager" ];
        # the main key is defined in common-nixos/cfg-ssh.nix; this is for remote building
        # maybe this should be a separate user?
        openssh.authorizedKeys.keyFiles = [ (r.extras + /id_ed25519-nix-remote-build.pub) ];
        packages = with pkgs; [
          virt-manager
        ];
        hashedPasswordFile = "/var/keys/${me}";
      };

      dann = {
        isNormalUser = true;
        description = "dann";
        hashedPasswordFile = "/var/keys/dann";
        shell = pkgs.shadow;
        uid = 1001;
      };
    };
  };

  home-manager.users.${me}.imports = [ ./home.nix ];

  system.stateVersion = "24.05"; # Did you read the comment?
}
