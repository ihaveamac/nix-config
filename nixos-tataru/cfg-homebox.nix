{ config, lib, pkgs, ... }:

let
  localPort = 7745;
in
{
  services.nginx = {
    virtualHosts."homebox.ihaveahax.net" = {
      useACMEHost = "ihaveahax.net";
      forceSSL = true;
      locations."/" = {
        recommendedProxySettings = true;
        proxyPass = "http://${config.containers.homebox.localAddress}:${toString localPort}";
      };
    };
  };

  # https://wiki.nixos.org/wiki/NixOS_Containers
  containers.homebox = {
    autoStart = true;
    ephemeral = true;
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";
    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::2";
    bindMounts.dataDir = {
      hostPath = "/var/lib/homebox";
      mountPoint = "/var/lib/homebox";
      isReadOnly = false;
    };
    forwardPorts = [
      {
        hostPort = localPort;
        containerPort = localPort;
        protocol = "tcp";
      }
    ];
    config = { config, pkgs, lib, ... }: {
      system.switch.enable = false;
      services.homebox = {
        enable = true;
        settings = {
          HBOX_WEB_PORT = toString localPort;
          TZ = "America/Chicago";
        };
      };

      networking = {
        firewall.allowedTCPPorts = [ localPort ];
        useHostResolvConf = lib.mkForce false;
      };

      system.stateVersion = "24.11";
    };
  };
}
