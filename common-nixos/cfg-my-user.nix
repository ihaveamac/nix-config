{ config, lib, pkgs, me, ... }:

{
  users.users.${me} = {
    description = me;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    linger = true;
    # this gets set by cfg-zsh.nix
    #shell = pkgs.zsh;
    uid = 1000;
  };

  users.users.root.shell = pkgs.zsh;
}
