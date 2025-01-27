{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  users.groups.nextcloud.members = [ "${config.services.jellyfin.user}" ];
}
