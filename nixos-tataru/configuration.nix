{
  config,
  lib,
  pkgs,
  me,
  r,
  inputs,
  modulesPath,
  ...
}:

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
    (r.common-nixos + /cfg-delete-old-hm-profiles.nix)
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
    inputs.sops-nix.nixosModules.sops
    "${modulesPath}/profiles/minimal.nix"
  ];

  sops = {
    defaultSopsFile = ../secrets/tataru/default.yaml;
    age = {
      keyFile = "/etc/sops-key.txt";
      generateKey = true;
    };
  };

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
      internalInterfaces = [ "ve-+" ];
      externalInterface = "eth0";
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
    collabora-online = {
      # TODO: re-enable once libreoffice-collabora is fixed
      # https://github.com/NixOS/nixpkgs/issues/383483
      enable = false;
      port = 9980;
      settings = {
        server_name = "coolwsd.ihaveahax.net";
        ssl.enable = false;
        ssl.termination = true;
      };
      aliasGroups = [
        {
          host = "https://homeserver.tail08e9a.ts.net";
        }
      ];
    };
    #nginx.virtualHosts."coolwsd.ihaveahax.net" = {
    #  useACMEHost = "ihaveahax.net";
    #  forceSSL = true;
    #  locations."/" = {
    #    recommendedProxySettings = true;
    #    proxyPass = "http://127.0.0.1:9980";
    #    proxyWebsockets = true;
    #  };
    #};
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

  home-manager.users.${me}.imports = [ ./home.nix ];

  system.stateVersion = "24.05";
}
