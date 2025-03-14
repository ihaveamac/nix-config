{
  config,
  lib,
  pkgs,
  me,
  r,
  inputs,
  my-inputs,
  ...
}:

let
  homedir = config.users.users.${me}.home;
in
{
  imports = [ my-inputs.home-manager-module ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs my-inputs r; };

    users.${me} =
      { pkgs, ... }:
      {
        # the order of this matters
        imports = [ ];

        home = {
          username = me;
          homeDirectory = homedir;
        };

        programs.home-manager.enable = lib.mkForce false;
        # I think this should be managed system-wide?
        fonts.fontconfig.enable = lib.mkForce false;

        # cannot be set when useGlobalPkgs is true
        nixpkgs.config = lib.mkForce null;
      };

    users.root =
      { pkgs, ... }:
      {
        imports = [ (r.common-home + /core-root.nix) ];

        home = {
          username = "root";
          homeDirectory = config.users.users.root.home;
        };

        programs.home-manager.enable = lib.mkForce false;

        # cannot be set when useGlobalPkgs is true
        nixpkgs.config = lib.mkForce null;
      };
  };
}
