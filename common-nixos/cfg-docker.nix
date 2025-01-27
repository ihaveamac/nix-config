{
  config,
  lib,
  pkgs,
  me,
  ...
}:

{
  virtualisation = {
    docker = {
      enable = true;
      # may be overridden to zfs, like it is on desktopnix
      storageDriver = "overlay2";
      daemon.settings = {
        # https://stackoverflow.com/questions/72952784/curl-could-not-resolve-host-using-docker-on-wsl-2
        dns = [ "8.8.8.8" ];
      };
    };
    oci-containers.backend = "docker";
  };

  users.groups.docker.members = [ "${me}" ];
}
