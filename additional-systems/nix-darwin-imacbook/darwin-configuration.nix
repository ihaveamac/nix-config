{ config, pkgs, lib, me, ... }:

{
  imports = [
    ../../common-nixos/cfg-sudo-config.nix
    ../../common-nixos/cfg-nix-homeserver-builder.nix
    ../../common-nixos/cfg-nix-settings.nix
    ../../extras/shared-nix-settings.nix
    ../../common-nixos/cfg-home-manager.nix
  ];
  environment.systemPackages = with pkgs; [
    vim
  ];

  users.users.${me} = {
    name = "${me}";
    home = "/Users/${me}";
    shell = pkgs.zsh; # doesn't work yet: https://github.com/LnL7/nix-darwin/issues/811
    openssh.authorizedKeys.keyFiles = [ ../../extras/id_rsa.pub ];
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

  system.darwinLabel = let
    cfg = config.system;
  in "${config.networking.hostName}-${cfg.nixpkgsVersion}+${cfg.darwinVersion}";

  # since ZDOTDIR is set globally, i don't need this useless .zshenv file (hopefully)
  home-manager.users.${me} = {
    imports = [
      ./home.nix
      ../../common-home/desktop.nix
      ../../common-home/core.nix
    ];
    home.file.".zshenv".enable = false;
  };

  networking.hostName = "Ians-MBP";

  system.stateVersion = 5;
}
