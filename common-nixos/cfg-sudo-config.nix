{ config, lib, pkgs, ... }:

{
  # https://new.reddit.com/r/NixOS/comments/1cf74pp/enable_sudo_password_feedback_nixos/
  security.sudo.extraConfig = ''
    Defaults env_reset,pwfeedback
    Defaults passprompt="[sudo] password for %p: "
    Defaults timestamp_timeout=15
  '';

  # sudo-rs does not implement preserve-env, which nextcloud-occ wants
  #security = {
  #  sudo.enable = false;
  #  sudo-rs.enable = true;
  #};
  #security.doas.enable = true;
}
