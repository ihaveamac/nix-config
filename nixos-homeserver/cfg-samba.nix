{ config, lib, pkgs, ... }:

{
  services = {
    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        "Jellyfin Media" = {
          path = "/data/jellyfin-media";
          browseable = "yes";
          comment = "files for use with Jellyfin";
          "valid users" = "ihaveahax nextcloud dann";
          "write list" = "ihaveahax dann";
          "force user" = "nextcloud";
          "force group" = "nextcloud";
          "create mask" = "0644";
        };
        global = {
          "guest account" = "nobody";
          "vfs objects" = "fruit streams_xattr";
          "fruit:metadata" = "stream";
          "fruit:model" = "MacSamba";
          "fruit:posix_rename" = "yes";
          "fruit:veto_appledouble" = "no";
          "fruit:nfs_aces" = "no";
          "fruit:wipe_intentionally_left_blank_rfork" = "yes";
          "fruit:delete_empty_adfiles" = "yes";
        };
      };
    };
    samba-wsdd = {
      enable = true;
      openFirewall = true;
      discovery = true;
    };
  };
}
