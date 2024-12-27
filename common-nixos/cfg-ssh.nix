{ config, pkgs, me, ... }:

{
  users.users = {
    root.openssh.authorizedKeys.keyFiles = [ ../extras/id_rsa.pub ];
    ${me}.openssh.authorizedKeys.keyFiles = [ ../extras/id_rsa.pub ];
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
    };
  };
  programs.ssh.startAgent = true;
}
