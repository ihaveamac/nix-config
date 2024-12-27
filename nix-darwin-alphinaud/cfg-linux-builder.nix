{ config, pkgs, lib, ... }:

{
  # this isn't as useful as i thought it'd be
  nix.linux-builder = {
    enable = true;
    # x86_64-linux doesn't work...
    # maybe i need to enable emulatedSystems?
    #systems = [ "x86_64-linux" "aarch64-linux" ];
    config = ({ pkgs, ... }: {
      virtualisation.darwin-builder = {
        memorySize = 6 * 1024;
      };
    # can't use the same attribute here because this refers to a linux version
    nix.package = pkgs.nixVersions.nix_2_22;
    });
  };
}
