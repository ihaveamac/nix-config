{ config, lib, pkgs, me, r, ... }:

let
  zshShared = pkgs.callPackage (r.extras + /shared-zsh-settings.nix) { inherit config; };
in
{
  programs.zsh = {
    enable = true;
  #  histFile = "$HOME/.local/state/zsh_history";
  #  histSize = 10000;
  #  autosuggestions.enable = true;
  #  syntaxHighlighting.enable = true;
  #  setOptions = zshShared.options;
  #  shellAliases = {
  #    nvl = "nix -v -L";
  #  } // config.home-manager.users.${me}.programs.zsh.shellAliases;
  #  ohMyZsh = {
  #    enable = true;
  #    plugins = zshShared.ohMyZsh.plugins;
  #  };
  #  shellInit = zshShared.shellInit;
  #  interactiveShellInit = ''
  #    # oh-my-zsh config
  #    ${zshShared.ohMyZsh.config};

  #    # global config
  #    ${zshShared.interactiveShellInit}
  #  '';
  #  loginShellInit = zshShared.loginShellInit;
  };

  environment.variables.ZDOTDIR = "$HOME/.config/zsh";

  # this gets configured in common-home/core.nix
  # maybe i'll move it over some time?
  #environment.systemPackages = with pkgs; [ eza ];

  users.users = {
  #  root.shell = pkgs.zsh;
    ${me}.shell = pkgs.zsh;
  };

  #home-manager.users.${me} = {
  #  xdg.configFile."zsh/.zshrc".text = "# This is to prevent zsh-newuser-install from running.";
  #  programs.zsh.enable = lib.mkForce false;
  #};
}
