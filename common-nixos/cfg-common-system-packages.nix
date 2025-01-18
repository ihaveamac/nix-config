{ config, lib, pkgs, me, ... }:

{
  options.hax.packages = with lib; {
    enableExtra = mkOption {
      default = true;
      description = "Enable additional packages not meant for slimmer setups.";
      type = types.bool;
    };
  };

  config = lib.mkMerge [
    ({ 
      environment.systemPackages = with pkgs; [
        wget
        pv
        git
        curl
        file
        psmisc
        btop
        zip
        unzip
        ( _7zz.override { enableUnfree = true; } )
        tree
        xxd
      ];
    })
    (lib.mkIf config.hax.packages.enableExtra {
      environment.systemPackages = with pkgs; [
        powershell
        usbutils
        binutils
        pciutils
        squashfuse # useful since i can use it as non-root, and override uid/gid
        attic-client
        nixfmt-rfc-style
        ( p7zip.override { enableUnfree = true; } )
      ];
    })
  ];
}
