{ lib, ... }:
{
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [
      "8.8.8.8"
    ];
    defaultGateway = "104.236.64.1";
    defaultGateway6 = {
      address = "2604:a880:800:10::1";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          {
            address = "104.236.76.172";
            prefixLength = 18;
          }
          {
            address = "10.17.0.5";
            prefixLength = 16;
          }
        ];
        ipv6.addresses = [
          {
            address = "2604:a880:800:10::640:a001";
            prefixLength = 64;
          }
          {
            address = "fe80::686f:b6ff:fea5:ab2";
            prefixLength = 64;
          }
        ];
        ipv4.routes = [
          {
            address = "104.236.64.1";
            prefixLength = 32;
          }
        ];
        ipv6.routes = [
          {
            address = "2604:a880:800:10::1";
            prefixLength = 128;
          }
        ];
      };
      eth1 = {
        ipv4.addresses = [
          {
            address = "10.108.0.2";
            prefixLength = 20;
          }
        ];
        ipv6.addresses = [
          {
            address = "fe80::b4b7:f7ff:fe65:5731";
            prefixLength = 64;
          }
        ];
      };
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="6a:6f:b6:a5:0a:b2", NAME="eth0"
    ATTR{address}=="b6:b7:f7:65:57:31", NAME="eth1"
  '';
}
