{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    user = "ihaveahax";
    dataDir = "/home/ihaveahax";
    openDefaultPorts = true;
  };

  networking.firewall.allowedTCPPorts = [ 8384 ];
}
