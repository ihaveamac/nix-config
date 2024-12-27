{ config, pkgs, ... }:

{
  virtualisation = {
    podman = {
      enable = true;
      dockerSocket.enable = true;
      dockerCompat = true;
    };

    containers.registries.search = pkgs.lib.mkForce [ "docker.io" ];
  };
}
