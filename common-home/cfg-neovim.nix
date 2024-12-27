{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    withPython3 = false;
    withRuby = false;
    withNodeJs = false;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-surround
      vim-toml
      vim-numbertoggle
      mediawiki-vim
      vim-gitgutter
      vim-commentary
      vim-markdown
      vim-auto-save
    ];
    extraConfig = builtins.readFile ../extras/neovim-config.vim;
  };
}
