{
  config,
  lib,
  pkgs,
  ...
}:

# THIS IS NOT A DERIVATION OR AN IMPORTABLE MODULE
# this gets called with pkgs.callPackage so I can use pkgs
# but it gets used in NixOS and Home Manager zsh modules
# this probably SHOULD be a module though...

let
  iterm2ShellIntegration = pkgs.fetchFromGitHub {
    owner = "gnachman";
    repo = "iTerm2-shell-integration";
    rev = "c2a41928ff1e224ecaa054035331b2a8aa7416a3";
    hash = "sha256-meYWZ3ZMsVVh8wMHALJuTjBLopcAa4LVpCRtClHJ7yA=";
  };
in
{
  # zshenv
  # NixOS: programs.zsh.shellInit
  # Home Manager: programs.zsh.envExtra
  shellInit = '''';

  # zshrc
  # NixOS: programs.zsh.interactiveShellInit
  # Home Manager: initContent
  interactiveShellInit = ''
    if [ `id -u` != 0 ]; then
      if [ "$IGNORE_DOTFILE_SECRETS" != "1" ]; then
        if [ -e "$HOME/.shellsecrets" ]; then
          source "$HOME/.shellsecrets"
        else
          echo "Could not find shellsecrets."
          echo "  git clone git@github.com:ihaveamac/dotfilesecrets ~/.dotfilesecrets"
          echo "  cd ~/.dotfilesecrets && ./link.bash"
        fi
      fi

      PS1_PROMPT_CHAR="%%"
    else
      PS1_PROMPT_CHAR="#"
    fi

    LOCALCOLOR_STOCK=$'%{\e[0m%}'
    if [ -z "$LOCALCOLOR" ]; then
      LOCALCOLOR=$LOCALCOLOR_STOCK
    fi

    #PS1=$'[%n@%m %c]%% ';
    #PS1=$'[''${LOCALCOLOR}%n@%m%{\e[0m%} %c]%% '
    PS1=$'[''${LOCALCOLOR}%n@%m%{\e[0m%} %d]\n''${PS1_PROMPT_CHAR} '
    RPS1=""

    # for nix-shell
    if [ -n "$IN_NIX_SHELL" ]; then
      PS1=$'%{\e[1;32m%}[''${IN_NIX_SHELL} nix-shell]%{\e[0m%} '"$PS1"
      # zsh-nix-shell causes my PATH additions to be put after the /nix/store stuff,
      # so i made a custom script to move the /nix/store paths to the front
      export PATH=$(${pkgs.python3}/bin/python3 -E ${./move-nix-store-paths-to-front.py})

    # for nix shell
    elif [ "$SHLVL" != "1" ]; then
      # in case this is actuall nix-shell
      if [ -z "$IN_NIX_SHELL" ]; then
        # make sure PATH actually has /nix/store paths in it
        if [[ "$PATH" == *"/nix/store"* ]]; then
          export IN_NIX_SHELL="flake impure"
          PS1=$'%{\e[1;32m%}[''${IN_NIX_SHELL} nix-shell]%{\e[0m%} '"$PS1"
          export PATH=$(${pkgs.python3}/bin/python3 -E ${./move-nix-store-paths-to-front.py})
        fi
      fi
    fi

    # TODO: make this a proper derivation
    #test -e "$ZDOTDIR/.iterm2_shell_integration.zsh" && source "$ZDOTDIR/.iterm2_shell_integration.zsh"
    #test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"
    source ${iterm2ShellIntegration}/shell_integration/zsh
    # should maybe not add a /nix/store thing directly to PATH
    PATH="$PATH:${iterm2ShellIntegration}/utilities";
  '';

  # zprofile
  # NixOS: programs.zsh.loginShellInit
  # Home Manager: programs.zsh.profileExtra
  loginShellInit = "";

  # options
  # NixOS: programs.zsh.setOptions
  # Home Manager: (requires manual setting)
  options = [
    "EXTENDED_HISTORY"
    "HIST_EXPIRE_DUPS_FIRST"
    "APPEND_HISTORY"
  ];

  ohMyZsh = {
    plugins = [
      "git"
      "docker"
      "docker-compose"
      "python"
    ] ++ (if config.programs.tmux.enable then [ "tmux" ] else [ ]);
    config = ''
      # no need for automatic updates with nix managing it
      zstyle ':omz:update' mode disabled
    '';
  };
}
