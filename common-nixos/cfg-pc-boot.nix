# pc-boot as in this applies to thancred (desktop PC) and homeserver
# not tataru (VPS) or asahinix (Apple Silicon Mac)
{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot = {
    loader = {
      grub = {
        enable = true;
        zfsSupport = true;
        efiSupport = true;
        mirroredBoots = [
          {
            devices = [ "nodev" ];
            path = "/boot";
          }
        ];
      };
      efi.canTouchEfiVariables = true;
    };
    tmp.cleanOnBoot = true;
  };
}
