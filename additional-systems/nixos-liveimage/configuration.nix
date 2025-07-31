{
  config,
  lib,
  pkgs,
  me,
  r,
  inputs,
  ...
}:

{
  imports = [
    "${inputs.nixos-unstable}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix"

    (r.extras + /shared-nix-settings.nix)
    (r.common-nixos + /cfg-misc.nix)
    (r.common-nixos + /cfg-common-system-packages.nix)
    (r.common-nixos + /cfg-linux-kernel.nix)
    (r.common-nixos + /cfg-home-manager.nix)
    (r.common-nixos + /cfg-xdg.nix)
    (r.common-nixos + /cfg-neovim.nix)
    (r.common-nixos + /cfg-zsh.nix)

    inputs.hax-nur.nixosModules.overlay
    inputs.lix-module.nixosModules.default
  ];

  isoImage.squashfsCompression = "zstd -Xcompression-level 1";

  # force x11
  services.displayManager.defaultSession = "plasmax11";

  system.nixos.tags = [
    "liveimage"
    config.boot.kernelPackages.kernel.name
  ];

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
    chntpw
    neofetch
    fastfetch
    hyfetch
  ];

  home-manager.users.${me}.imports = [
    ./home.nix
  ];
}
