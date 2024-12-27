{ config, lib, pkgs, me, ... }:

{
  # maybe this could become a proper derivation at some point,
  # but disnake is not in nixpkgs, so that's a pain
  virtualisation.oci-containers.containers.rolebot = {
    image = "ghcr.io/eibex/reaction-light:latest";
    volumes = [
      "/opt/docker/rolebot-hax/config.ini:/bot/config.ini"
      "/opt/docker/rolebot-hax/files:/bot/files"
    ];
  };
}
