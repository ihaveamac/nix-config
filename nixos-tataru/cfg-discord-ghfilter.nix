{ config, lib, pkgs, me, ... }:

let
  pythonPackages = pkgs.python3Packages;
  ghfilter-env = pythonPackages.python.buildEnv.override {
    extraLibs = [ pythonPackages.aiohttp ];
  };
  localPort = "9124";
  listenUrl = "/nocrowdin";
in
{
  sops.secrets."ghfilter-webhook-url" = {};

  systemd.services.ghfilter = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    requires = [ "network-online.target" ];
    description = "GitHub Crowdin webook filter";
    environment = {
      PYTHONUNBUFFERED = "1";
    };
    serviceConfig = {
      Type = "exec";
      PrivateTmp = true;
      ExecStart = "${ghfilter-env}/bin/python3 ${./ghfilter/filter.py} ${config.sops.secrets.ghfilter-webhook-url.path} ${localPort} ${listenUrl}";
      Restart = "on-failure";
    };
  };

  services.nginx.virtualHosts."webhookfilter-tataru.ihaveahax.net" = {
    useACMEHost = "ihaveahax.net";
    forceSSL = true;
    locations."/" = {
      recommendedProxySettings = true;
      proxyPass = "http://127.0.0.1:${localPort}";
    };
  };
}
