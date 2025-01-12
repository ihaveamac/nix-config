{ config, lib, pkgs, my-inputs, ... }:

{
  imports = [
    ./cfg-neovim.nix
    ./cfg-zsh.nix
    ./cfg-git.nix
    ./cfg-ssh.nix
    ./cfg-vifm.nix
    ./cfg-xdg.nix
  ];

  programs = {
    eza = {
      enable = true;
      git = true;
      icons = "auto";
      extraOptions = [
        "--group-directories-first"
        "--header"
        "--group"
      ];
    };
    bat = {
      enable = true;
      # all of them are broken
      #extraPackages = with pkgs.bat-extras; [ batdiff batman batgrep batwatch ];
    };
    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
    ripgrep.enable = true;
    yt-dlp = {
      enable = true;
    };
    tmux.enable = true;
  };

  home.packages = with pkgs; [
    pv
    wget
    xz
    tree
    curl
    s3cmd
    zstd
    colordiff
    gist
    # error in a test, i think
    #magic-wormhole
    magic-wormhole-rs
    cachix
    nix-tree
    rsync
    megatools
    gdown
  ];

  home.sessionVariables = with config.xdg; {
    # https://www.reddit.com/r/archlinux/comments/1fpk3p0/most_useful_package/lp2dpu1/
    MANPAGER = "nvim +Man!";
  };

  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "24.05"; # Please read the comment before changing.
}
