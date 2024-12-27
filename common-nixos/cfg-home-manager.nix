{ config, lib, pkgs, me, inputs, my-inputs, ... }:

let
  homedir = config.users.users.${me}.home;
in
{
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs my-inputs; };

    users.${me} = { pkgs, ... }: {
      # the order of this matters
      imports = [ ];

      home = {
        username = me;
        homeDirectory = homedir;
      };

      programs.home-manager.enable = lib.mkForce false;
      # I think this should be managed system-wide?
      fonts.fontconfig.enable = lib.mkForce false;
    };

    users.root = { pkgs, ... }: {
      imports = [ ../common-home/core-root.nix ];

      home = {
        username = "root";
        homeDirectory = config.users.users.root.home;
      };

      programs.home-manager.enable = lib.mkForce false;
    };
  };
}
