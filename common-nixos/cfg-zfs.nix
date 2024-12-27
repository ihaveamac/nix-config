{ config, lib, pkgs, ... }:

{
  boot = {
    #kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    supportedFilesystems = [ "zfs" ];
    zfs.forceImportRoot = true;
  };
}
