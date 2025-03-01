# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "zpool/root";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "zpool/nix";
    fsType = "zfs";
  };

  fileSystems."/var" = {
    device = "zpool/var";
    fsType = "zfs";
  };

  fileSystems."/var/lib/docker" = {
    device = "zpool/var-lib-docker";
    fsType = "zfs";
  };

  fileSystems."/var/lib/nextcloud" = {
    device = "zpool/var-lib-nextcloud";
    fsType = "zfs";
  };

  fileSystems."/var/lib/postgresql" = {
    device = "zpool/var-lib-postgresql";
    fsType = "zfs";
  };

  fileSystems."/var/lib/libvirt" = {
    device = "zpool/var-lib-libvirt";
    fsType = "zfs";
  };

  #fileSystems."/var/lib/minecraft" =
  #  { device = "zpool/var-lib-minecraft";
  #    fsType = "zfs";
  #  };

  fileSystems."/data/jellyfin-media" = {
    device = "zpool/data-jellyfin-media";
    fsType = "zfs";
  };

  fileSystems."/data/ftp" = {
    device = "zpool/data-ftp";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "zpool/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/535B-CC63";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
