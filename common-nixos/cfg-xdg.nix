{ config, lib, pkgs, me, ... }:

{
  environment.sessionVariables = {
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_CACHE_HOME = "$HOME/.cache";
    ZDOTDIR = "$HOME/.config/zsh";
  };

  programs.bash.shellInit = ''
    export HISTFILE=${config.environment.sessionVariables.XDG_STATE_HOME}/bash_history
  '';

  # since ZDOTDIR is set globally, i don't need this useless .zshenv file
  home-manager.users.${me}.home.file.".zshenv".enable = false;
  home-manager.users.root.home.file.".zshenv".enable = false;
}
