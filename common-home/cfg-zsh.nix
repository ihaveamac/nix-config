{ config, lib, pkgs, r, ... }:

let
  zshShared = pkgs.callPackage (r.extras + /shared-zsh-settings.nix) { inherit config; };
in
{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      append = true;
      path = "$HOME/.local/state/zsh_history";
    };
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      nv = "nvim";
      hactool = "hactool --disablekeywarns";
      amke = "make";
      mkae = "make";
      nvl = "nix -v -L";
    };
    oh-my-zsh = {
      enable = true;
      plugins = zshShared.ohMyZsh.plugins;
      extraConfig = zshShared.ohMyZsh.config;
    };
    envExtra = zshShared.shellInit;
    initExtra = ''
      # manually set options
      ${lib.optionalString (zshShared.options != []) ''
        # Set zsh options.
        setopt ${builtins.concatStringsSep " " zshShared.options}
      ''}

      # global config
      ${zshShared.interactiveShellInit}
    '';
    profileExtra = zshShared.loginShellInit;
  };

  programs.nix-your-shell.enable = true;
}
