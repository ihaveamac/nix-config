{ config, lib, pkgs, me, inputs, ... }:

{
  imports = [ inputs.srcds-nix.nixosModules.default ];

  services.srcds.enable = true;
  services.srcds.openFirewall = true;
  services.srcds.games = {
    tf2 = {
      appId = 232250;
      gamePort = 27015;
      startingMap = "pl_upward";
      rcon = {
        enable = true;
        password = "ihaveahax";
      };
      config = {
        hostname = "NixOS srcds-nix test";
        sv_password = "ihaveahax";
      };
      extraConfig = ''
        echo extraConfig executed
      '';
    };
  };
}
