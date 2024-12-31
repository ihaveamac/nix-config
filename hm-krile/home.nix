{ config, lib, pkgs, r, inputs, ... }:

{
  imports = [
    (r.common-home + /linux.nix)
    (r.common-home + /desktop.nix)
    (r.common-home + /core.nix)
    (r.common-home + /non-nixos.nix)
    (r.extras + /shared-nix-settings.nix)
    inputs.hax-nur.hmModules.lnshot
    inputs.lix-module.nixosModules.default
  ];

  programs = {
    firefox = {
      enable = true;
      nativeMessagingHosts = with pkgs; [
        libsForQt5.plasma-browser-integration
        keepassxc  # remember to configure KeePassXC to not update this file
      ];
      policies = import (r.extras + /firefox-policies.nix);
      package = pkgs.firefox-esr-128;
    };
    zsh = {
      initExtraFirst = ''
        ######################################################################
        # begin hm-krile/home.nix (first)

        #if [ "$SteamEnv" = "1" ]; then
        #  echo "Running in SteamEnv, unsetting LD_PRELOAD"
        #  export LD_PRELOAD=""
        #fi

        # end hm-krile/home.nix (first)
      '';
      envExtra = ''
        ######################################################################
        # begin hm-krile/home.nix

        export PATH="$HOME/.local/bin:$PATH"
        export PATH="$HOME/bin:$PATH"
        export PATH="$HOME/.local/share/JetBrains/Toolbox/scripts:$PATH"

        # end hm-krile/home.nix
      '';
      initExtra = ''
        ######################################################################
        # begin hm-krile/home.nix

        # NOTE TO SELF:
        # XDG_DATA_DIRS are also set at ~/.config/plasma-workspace/env

        #PS1=$'[%{\e[1;35m%}%n@%m%{\e[0m%} %c]%% '  # for steam deck
        LOCALCOLOR=$'%{\e[1;35m%}'

        if [ -e /usr/share/applications/org.mozilla.firefox.desktop ]; then
          echo $'\e[1;32mIt seems packages need reinstalling. Run reinstall-packages\e[0m'
        fi

        # end hm-krile/home.nix
      '';
    };
  };

  systemd.user = {
    # workaround tray.target missing
    # https://github.com/nix-community/home-manager/issues/2064#issuecomment-887300055
    targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = [ "graphical-session-pre.target" ];
      };
    };
  };

  services = {
    ssh-agent.enable = true;
    lnshot.enable = true;
    syncthing = {
      enable = true;
      # tray.enable is not useful here because it errors out in Game Mode
      # separately, it doesn't seem to work that way either...
    };
  };

  home = {
    username = "deck";
    homeDirectory = "/home/deck";
    packages = with pkgs; [
      inetutils
      # discord  # did not work in Steam
      vesktop
      keepassxc
      docker-client
      docker-compose
      # this re-installs some stuff to the root, stuff i can't do in nix for some reason
      # in particular for steamos-docker
      (pkgs.writeShellScriptBin "reinstall-packages" ''
        if [[ "$(id -u)" -ne 0 ]]; then
          echo "$(basename $0) needs to be run as root"
          sudo bash -x "$0" "$*"
          exit
        fi

        set -x
        steamos-readonly disable
        rm /usr/share/applications/org.mozilla.firefox.desktop
        pacman-key --init
        pacman-key --populate archlinux holo
        pacman -S --noconfirm --needed --overwrite \* make fakeroot fakechroot
        steamos-readonly enable
      '')
    ];

    shellAliases = {
      # this needs more variables to be truly accurate...
      "link-to-desktop" = ''
        export XAUTHORITY=/tmp/deck-xauthority
        export DISPLAY=:0
        echo Linked to $XAUTHORITY display $DISPLAY
      '';
    };

    sessionVariables = {
      # podman docker socket (systemctl enable --user --now podman.socket)
      DOCKER_HOST = "unix:///run/user/1000/podman/podman.sock";
    };

    file = {
      ".config/environment.d/00-nix-xdgdata.conf".text = ''
        ZZ_XDG_DATA_DIRS=$HOME/.nix-profile/share:$XDG_DATA_DIRS
        DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
      '';
      # why does environment.d not wanna work?!?!?
      ".config/plasma-workspace/env/nix-xdg.sh" = {
        text = ''
          export ZZZ_XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
        '';
        executable = true;
      };
      ".config/plasma-workspace/env/link-xauthority.sh" = {
        text = ''
          ln -s $XAUTHORITY /tmp/deck-xauthority
        '';
      };
    };
  };
}
