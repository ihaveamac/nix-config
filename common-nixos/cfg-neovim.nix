{
  config,
  lib,
  pkgs,
  me,
  r,
  ...
}:

{
  programs.neovim = {
    enable = true;
    withPython3 = false;
    withRuby = false;
    withNodeJs = false;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = builtins.readFile (r.extras + /neovim-config.vim);
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          vim-surround
          vim-toml
          vim-numbertoggle
          mediawiki-vim
          vim-gitgutter
          vim-commentary
          vim-markdown
          vim-auto-save
        ];
      };
    };
  };

  # don't need the home-manager one
  home-manager.users.${me}.programs.neovim.enable = lib.mkForce false;
  home-manager.users.root.programs.neovim.enable = lib.mkForce false;

  environment.variables.MANPAGER = "nvim +Man!";
}
