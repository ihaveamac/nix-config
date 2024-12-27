{ config, pkgs, ... }:

{
  #programs.ssh = {
  #  enable = true;
  #  addKeysToAgent = "ask";
  #};
  #services.ssh-agent.enable = true;

  programs.zsh = {
    shellAliases = {
      pbcopy = "xclip -selection clipboard";
    };
  };

  home.packages = with pkgs; [ xclip ];
}
