{
  config,
  pkgs,
  r,
  ...
}:

{
  home.packages =
    (with pkgs; [
      dos2unix
      jo
      jq
      flac
      squashfsTools
      qrencode
      doctl
      imagemagick
      twine
      cdecrypt
    ])
    ++ (
      if pkgs.stdenv.isDarwin || (pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64) then [ pkgs.rar ] else [ ]
    )
    ++ (pkgs.callPackage (r.extras + /fonts.nix) { });

  # note: disabled in nix-darwin-alphinaud/home.nix
  # note: disabled in common-nixos/cfg-home-manager.nix
  fonts.fontconfig.enable = true;

  programs.pandoc.enable = true;

  programs.zsh = {
    oh-my-zsh.plugins = [ "doctl" ];
    initContent = ''
      ######################################################################
      # begin home/desktop.nix

      # end home/desktop.nix
    '';
  };

  xdg.configFile = {
    "ideavim/ideavimrc".text = ''
      set surround
      nmap <C-K> o<Esc>
      # https://stackoverflow.com/questions/27898407/intellij-idea-with-ideavim-cannot-copy-text-from-another-source
      set clipboard+=unnamed
    '';
  };
}
