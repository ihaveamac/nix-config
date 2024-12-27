{ config, lib, pkgs, me, ... }:

{
  # i don't currently feel like turning this into a NixOS service
  # maybe when it's 1.9 in nixpkgs?

  virtualisation.oci-containers.containers.znc = {
    image = "znc:1.9";
    ports = [ "5000:5000" ];
    volumes = [ "/opt/znc-docker:/znc-data" ];
  };

  networking.firewall.allowedTCPPorts = [ 5000 ];

  #services.znc = {
  #  enable = true;
  #  confOptions = {
  #    userName = "ihaveamac";
  #  };
  #  config = {
  #    User.ihaveamac = {
  #      Admin = true;
  #      Pass.password = {
  #      };
  #    }:
  #  };
  #  modulePackages = with pkgs.zncModules; [ palaver clientbuffer ];
  #};
}
