{
  config,
  pkgs,
  lib,
  me,
  r,
  inputs,
  ...
}:

{
  imports = [
    (r.extras + /shared-nix-settings.nix)
    (r.common-nixos + /cfg-sudo-config.nix)
    (r.common-nixos + /cfg-nix-homeserver-builder.nix)
    (r.common-nixos + /cfg-nix-settings.nix)
    (r.common-nixos + /cfg-home-manager.nix)
    inputs.hax-nur.nixosModules.overlay
    inputs.lix-module.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    vim
  ];

  users.users.${me} = {
    name = "${me}";
    home = "/Users/${me}";
    shell = pkgs.zsh; # doesn't work yet: https://github.com/LnL7/nix-darwin/issues/811
    openssh.authorizedKeys.keyFiles = [ (r.extras + /id_rsa.pub) ];
  };

  environment.variables = {
    MANPATH = "/usr/local/share/man\${MANPATH+:$MANPATH}:";
    PATH = "/usr/local/bin:/usr/local/sbin:/usr/local/zfs/bin\${PATH+:$PATH}";
    INFOPATH = "/usr/local/share/info:\${INFOPATH:-}";
    HOMEBREW_PREFIX = "/usr/local";
    HOMEBREW_CELLAR = "/usr/local/Cellar";
    HOMEBREW_REPOSITORY = "/usr/local";
    PKG_CONFIG_PATH = "/usr/local/lib/pkgconfig";
    # this fixed building rust crates that use the fuser crate for x86_64 while on arm64
    PKG_CONFIG_SYSROOT_DIR = "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk";
    ZDOTDIR = "$HOME/.config/zsh"; # so hopefully i can remove ~/.zshenv
  };

  environment.shells = with pkgs; [ zsh ];

  services.nix-daemon.enable = true;

  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.tmux.enable = true;

  system.darwinLabel =
    let
      cfg = config.system;
    in
    "${config.networking.hostName}-${cfg.nixpkgsVersion}+${cfg.darwinVersion}";

  # since ZDOTDIR is set globally, i don't need this useless .zshenv file (hopefully)
  home-manager.users.${me} = {
    imports = [
      ./home.nix
      (r.common-home + /desktop.nix)
      (r.common-home + /core.nix)
    ];
    home.file.".zshenv".enable = false;
  };

  networking.hostName = "Ians-MBP";

  system.stateVersion = 5;
}
