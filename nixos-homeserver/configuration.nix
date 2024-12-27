{ config, lib, pkgs, me, ... }:

{
  imports = [
    ../common-nixos/cfg-misc.nix
    ../common-nixos/cfg-common-system-packages.nix
    ../common-nixos/cfg-linux-kernel.nix
    ../common-nixos/cfg-my-user.nix
    ../common-nixos/cfg-pc-boot.nix
    ../common-nixos/cfg-docker.nix
    ../common-nixos/cfg-time-and-i18n.nix
    ../common-nixos/cfg-disable-sleep.nix
    ../common-nixos/cfg-sudo-config.nix
    ../common-nixos/cfg-zfs.nix
    ../common-nixos/cfg-avahi.nix
    ../common-nixos/cfg-shell-aliases.nix
    ../common-nixos/cfg-libvirt.nix
    ../common-nixos/cfg-python-environment.nix
    ../common-nixos/cfg-auto-optimise.nix
    ../common-nixos/cfg-darling.nix
    ../common-nixos/cfg-xdg.nix
    ../common-nixos/cfg-neovim.nix
    ../common-nixos/cfg-zsh.nix
    ../common-nixos/cfg-syncthing.nix
    ./cfg-nextcloud.nix
    ./cfg-postgres.nix
    ./cfg-jellyfin.nix
    ./cfg-samba.nix
    ./cfg-discord-rolebot.nix
    ./cfg-discord-red-bot.nix
    ./cfg-discord-modmail-hax.nix
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
        openssh.authorizedKeys.keyFiles = [ ../extras/id_ed25519-nix-remote-build.pub ];
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

  system.stateVersion = "24.05"; # Did you read the comment?
}
