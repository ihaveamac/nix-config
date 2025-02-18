{
  config,
  pkgs,
  lib,
  me,
  ...
}:

{
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
    };

    containers.registries.search = lib.mkForce [ "docker.io" ];
  };

  users.users.${me} = {
    extraGroups = [ "podman" ];
    subUidRanges = [
      {
        count = 99999;
        startUid = 100000;
      }
    ];
    subGidRanges = [
      {
        count = 99999;
        startGid = 100000;
      }
    ];
  };
}
