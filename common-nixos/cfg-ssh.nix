{
  config,
  pkgs,
  me,
  r,
  ...
}:

{
  users.users = {
    root.openssh.authorizedKeys.keyFiles = [ (r.extras + /id_rsa.pub) ];
    ${me}.openssh.authorizedKeys.keyFiles = [ (r.extras + /id_rsa.pub) ];
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
