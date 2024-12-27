{ config, lib, pkgs, ... }:

{
  nix.optimise = {
    automatic = true;
    # for some reason, this option was removed from nix-darwin (???)
    # so i must manually add it to the nix-darwin config
    dates = [ "04:00" ];
  };
}
