{
  config,
  lib,
  pkgs,
  me,
  ...
}:

{
  # maybe this could become a proper derivation at some point,
  # but disnake is not in nixpkgs, so that's a pain
  virtualisation.oci-containers.containers.modmail-hax = {
    image = "ianburgwin/discord-mod-mail:latest";
    volumes = [
      "/opt/docker/modmail-hax:/home/modmail/data"
    ];
  };
}
