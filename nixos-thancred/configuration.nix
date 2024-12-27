{ config, lib, pkgs, me, my-inputs, ... }:

{
  imports = [
    ../common-nixos/cfg-misc.nix
    ../common-nixos/cfg-common-system-packages.nix
    ../common-nixos/cfg-linux-kernel.nix
    ../common-nixos/cfg-my-user.nix
    ../common-nixos/cfg-pc-boot.nix
    ../common-nixos/cfg-docker.nix
    ../common-nixos/cfg-plasma6.nix
    ../common-nixos/cfg-time-and-i18n.nix
    ../common-nixos/cfg-sound.nix
    ../common-nixos/cfg-nix-homeserver-builder.nix
    ../common-nixos/cfg-disable-sleep.nix
    ../common-nixos/cfg-sudo-config.nix
    ../common-nixos/cfg-zfs.nix
    ../common-nixos/cfg-avahi.nix
    ../common-nixos/cfg-shell-aliases.nix
    ../common-nixos/cfg-firefox.nix
    ../common-nixos/cfg-python-environment.nix
    ../common-nixos/cfg-auto-optimise.nix
    ../common-nixos/cfg-darling.nix
    ../common-nixos/cfg-xdg.nix
    ../common-nixos/cfg-neovim.nix
    ../common-nixos/cfg-zsh.nix
    ../common-nixos/cfg-syncthing.nix
    ./cfg-nvidia.nix
    #./cfg-specialisation-no-gui.nix
    ./cfg-java.nix
  ];

  system.nixos.tags = [ config.boot.kernelPackages.kernel.name ];

  specialisation = {
    #nouveau.configuration = {
    #  system.nixos.tags = [ "nouveau" ];
    #  # remove nvidia from the list
    #  services.xserver.videoDrivers = lib.mkForce [ ];
    #};
    #nvidia-560.configuration = {
    #  system.nixos.tags = [ "nvidia-560" ];
    #  hardware.nvidia.package = lib.mkForce (config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #    version = "560.35.03";
    #    sha256_64bit = "sha256-8pMskvrdQ8WyNBvkU/xPc/CtcYXCa7ekP73oGuKfH+M=";
    #    sha256_aarch64 = lib.fakeHash;
    #    openSha256 = "sha256-/32Zf0dKrofTmPZ3Ratw4vDM7B+OgpC4p7s+RHUjCrg=";
    #    settingsSha256 = "sha256-kQsvDgnxis9ANFmwIwB7HX5MkIAcpEEAHc8IBOLdXvk=";
    #    persistencedSha256 = "sha256-E2J2wYYyRu7Kc3MMZz/8ZIemcZg68rkzvqEwFAL3fFs=";
    #  });
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
      apfs = true;
      squashfs = true;
    };
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
    packages = pkgs.callPackage ../extras/fonts.nix {};
    enableDefaultPackages = true;
  };

  programs = {
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin steamtinkerlaunch ];
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      dedicatedServer.openFirewall = true;
      protontricks.enable = true;
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
    vmware.host.enable = true;
    docker = {
      storageDriver = lib.mkForce "zfs";
      daemon.settings = {
        data-root = "/mnt/ExtraSSD/docker";
      };
    };
  };

  users.users.${me} = {
    extraGroups = [ "networkmanager" "gamemode" ];
    packages = (with pkgs; [
      keepassxc
      ( xivlauncher.overrideAttrs (final: prev: {
        postFixup = prev.postFixup + ''
          substituteInPlace $out/share/applications/xivlauncher.desktop \
            --replace-fail "Exec=XIVLauncher.Core" "Exec=gamemoderun XIVLauncher.Core"
        '';
      } ) )
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
      ( lutris.override { extraPkgs = pkgs: [ pkgs.wineWow64Packages.unstableFull ]; } )
      remmina
      hax.kwin-move-window
      virt-manager
      nextcloud-client
      handbrake
      makemkv
      gimp
      dvdisaster
      audacity
      prismlauncher
      steamtinkerlaunch
      signal-desktop
      finamp
      # ffmpeg override: https://github.com/NixOS/nixpkgs/issues/358765
      # https://github.com/NixOS/nixpkgs/pull/366880
      # crashes immediately on launch in wayland, so i also have to force xwayland
      ( ( subtitlecomposer.override { ffmpeg = ffmpeg_6; } ).overrideAttrs (final: prev: {
        postInstall = ''
          substituteInPlace $out/share/applications/org.kde.subtitlecomposer.desktop \
            --replace-fail "Exec=subtitlecomposer %f" "Exec=WAYLAND_DISPLAY="" subtitlecomposer %f"
        '';
      }) )
    ]) ++ (with pkgs.kdePackages; [
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

  system.stateVersion = "24.05";
}
