{ config, lib, pkgs, me, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      #package = pkgs.qemu_kvm; # only do host architecture
      swtpm.enable = true;
    };
  };

  users.users.${me}.extraGroups = [ "libvirtd" "qemu-libvirtd" ];
}
