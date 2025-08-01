{
  config,
  lib,
  pkgs,
  me,
  r,
  inputs,
  my-inputs,
  ...
}:

{
  imports = [
    (r.extras + /shared-nix-settings.nix)
    (r.common-nixos + /cfg-misc.nix)
    (r.common-nixos + /cfg-common-system-packages.nix)
    (r.common-nixos + /cfg-linux-kernel.nix)
    (r.common-nixos + /cfg-home-manager.nix)
    (r.common-nixos + /cfg-ssh.nix)
    (r.common-nixos + /cfg-nix-settings.nix)
    (r.common-nixos + /cfg-my-user.nix)
    (r.common-nixos + /cfg-pc-boot.nix)
    (r.common-nixos + /cfg-docker.nix)
    (r.common-nixos + /cfg-podman.nix)
    (r.common-nixos + /cfg-plasma6.nix)
    (r.common-nixos + /cfg-time-and-i18n.nix)
    (r.common-nixos + /cfg-sound.nix)
    (r.common-nixos + /cfg-nix-homeserver-builder.nix)
    (r.common-nixos + /cfg-disable-sleep.nix)
    (r.common-nixos + /cfg-sudo-config.nix)
    (r.common-nixos + /cfg-zfs.nix)
    (r.common-nixos + /cfg-avahi.nix)
    (r.common-nixos + /cfg-shell-aliases.nix)
    (r.common-nixos + /cfg-firefox.nix)
    (r.common-nixos + /cfg-python-environment.nix)
    (r.common-nixos + /cfg-auto-optimise.nix)
    (r.common-nixos + /cfg-xdg.nix)
    (r.common-nixos + /cfg-neovim.nix)
    (r.common-nixos + /cfg-zsh.nix)
    (r.common-nixos + /cfg-syncthing.nix)
    ./hardware-configuration.nix
    ./cfg-nvidia.nix
    #./cfg-specialisation-no-gui.nix
    ./cfg-java.nix

    inputs.hax-nur.nixosModules.overlay
    inputs.lix-module.nixosModules.default
  ];

  system.nixos.tags = [ config.boot.kernelPackages.kernel.name ];

  specialisation = {
    #nouveau.configuration = {
    #  system.nixos.tags = [ "nouveau" ];
    #  # remove nvidia from the list
    #  services.xserver.videoDrivers = lib.mkForce [ ];
    #};
  };

  boot = {
    loader = {
      grub = {
        configurationLimit = 5;
        timeoutStyle = "hidden";
      };
      timeout = 1;
    };
    kernelModules = [ "sg" ]; # needed for MakeMKV
    supportedFilesystems = {
      ntfs = true;
      # broken with 6.14
      #apfs = true;
      squashfs = true;
    };
    # set Magic Keyboard fn keys to be fn keys by default
    extraModprobeConfig = ''
      options hid_apple fnmode=2
    '';
  };

  networking = {
    networkmanager.enable = true;
    hostId = "eae9dea6";
    hostName = "thancred";
    firewall.allowedTCPPorts = [
      4646 # XIVLauncher Authenticator
      8000 # Python http.server
      17491 # 3dslink server
    ];
    # https://wiki.nixos.org/wiki/NixOS_Containers
    nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = "wlp0s20u5"; # i feel like this is unstable
      # Lazy IPv6 connectivity for the container
      enableIPv6 = true;
    };
  };

  services = {
    # i don't need this until we get a printer, IF we get a printer
    # (remember the library exists!)
    #printing.enable = true;
    hardware.openrgb.enable = true;
    tailscale.enable = true;
    flatpak.enable = true;
  };

  environment.systemPackages = with pkgs; [
    smartmontools
    dualsensectl
    ghostscript
    groff
    my-inputs.ninfs.ninfs
    ffmpeg_7-full
    sops
    alsa-utils # mainly for arecord | aplay
  ];

  environment.sessionVariables = {
    # should work now as of 130
    MOZ_ENABLE_WAYLAND = 1;
  };

  hardware = {
    # xpadneo supports the elite controller
    #xone.enable = true;
    xpadneo.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  fonts = {
    packages = pkgs.callPackage (r.extras + /fonts.nix) { };
    enableDefaultPackages = true;
  };

  programs = {
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
        steamtinkerlaunch
      ];
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      dedicatedServer.openFirewall = true;
      protontricks.enable = true;
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    gamemode.enable = true;
    partition-manager.enable = true;
    kdeconnect.enable = true;
    java.enable = true;
    traceroute.enable = true;
    zsh = {
      shellInit = ''
        LOCALCOLOR=$'%{\e[1;31m%}'
      '';
    };
    tmux.enable = true;
    gnupg.agent.enable = true;
    nix-ld.enable = true;
    thunderbird = {
      enable = true;
      package = pkgs.thunderbird-128;
    };
    appimage = {
      enable = true;
      binfmt = true;
    };
  };

  virtualisation = {
    # needs a login
    #vmware.host.enable = true;
    docker = {
      storageDriver = lib.mkForce "zfs";
      daemon.settings = {
        data-root = "/mnt/ExtraSSD/docker";
      };
    };
  };

  users.users.${me} = {
    extraGroups = [
      "networkmanager"
      "gamemode"
    ];
    packages =
      (with pkgs; [
        keepassxc
        (xivlauncher.overrideAttrs (
          final: prev: {
            postFixup =
              prev.postFixup
              + ''
                substituteInPlace $out/share/applications/xivlauncher.desktop \
                  --replace-fail "Exec=XIVLauncher.Core" "Exec=gamemoderun XIVLauncher.Core"
              '';
          }
        ))
        vesktop
        discord
        telegram-desktop
        libreoffice-qt6
        krita
        barrier
        localsend
        okteta
        jetbrains.pycharm-professional
        jetbrains.phpstorm
        vlc
        wineWow64Packages.unstableFull
        (lutris.override { extraPkgs = pkgs: [ pkgs.wineWow64Packages.unstableFull ]; })
        remmina
        hax.kwin-move-window
        virt-manager
        nextcloud-client
        handbrake
        makemkv
        gimp3
        # build failure
        #dvdisaster
        # TODO: https://github.com/NixOS/nixpkgs/issues/428792
        #audacity
        # i set up my jdks differently (but this needs at least one in the list)
        ( prismlauncher.override { jdks = [ jdk21 ]; } )
        steamtinkerlaunch
        signal-desktop
        finamp
        imhex
        dolphin-emu
        qpwgraph
        # crashes immediately on launch in wayland, so i also have to force xwayland
        (subtitlecomposer.overrideAttrs (
          final: prev: {
            postInstall = ''
              substituteInPlace $out/share/applications/org.kde.subtitlecomposer.desktop \
                --replace-fail "Exec=subtitlecomposer %f" "Exec=WAYLAND_DISPLAY="" subtitlecomposer %f"
            '';
          }
        ))
      ])
      ++ (with pkgs.kdePackages; [
        filelight
        tokodon
        kcalc
        # doesn't work when launched from the menu: "execve: No such file or directory"
        #ksystemlog
        isoimagewriter
        yakuake
        kdenlive
        kpat
      ]);
  };

  hax.homeserverHostName = "192.168.1.10";

  home-manager.users.${me}.imports = [ ./home.nix ];

  system.stateVersion = "24.05";
}
