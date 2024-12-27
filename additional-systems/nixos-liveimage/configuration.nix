{ config, lib, pkgs, me, ... }:

{
  imports = [
    ../../common-nixos/cfg-misc.nix
    ../../common-nixos/cfg-common-system-packages.nix
    ../../common-nixos/cfg-linux-kernel.nix
    ../../common-nixos/cfg-xdg.nix
    ../../common-nixos/cfg-neovim.nix
    ../../common-nixos/cfg-zsh.nix
  ];
  isoImage.squashfsCompression = "zstd -Xcompression-level 1";

  # force x11
  services.displayManager.defaultSession = "plasmax11";

  system.nixos.tags = [ "liveimage" config.boot.kernelPackages.kernel.name ];

  boot = {
    zfs.package = pkgs.zfs_unstable;
    supportedFilesystems = {
      apfs = true;
    };
  };

  # this was causing build issues, and i don't need it anyway
  virtualisation.hypervGuest.enable = lib.mkForce false;

  environment.sessionVariables = {
    IGNORE_DOTFILE_SECRETS = 1;
  };

  environment.etc."pacman.conf".text = ''
    [options]
    HoldPkg = pacman glibc
    Architecture = auto
    CheckSpace
    SigLevel = Required DatabaseOptional
    LocalFileSigLevel = Optional
    [core]
    Server = https://mirror.wdc1.us.leaseweb.net/archlinux/$repo/os/$arch
    [extra]
    Server = https://mirror.wdc1.us.leaseweb.net/archlinux/$repo/os/$arch
  '';

  environment.systemPackages = with pkgs; [
    arch-install-scripts
    pacman
    debianutils
    dpkg
    dnf5
    debootstrap
    neovim
    discord
    python3Packages.python
    smartmontools
  ];

}
