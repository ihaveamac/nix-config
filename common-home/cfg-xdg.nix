{ config, pkgs, ... }:

{
  home = {
    sessionVariables = with config.xdg; {
      XDG_DATA_HOME = dataHome;
      XDG_CONFIG_HOME = configHome;
      XDG_STATE_HOME = stateHome;
      XDG_CACHE_HOME = cacheHome;

      CUDA_CACHE_PATH = "${cacheHome}/nv";
      DOCKER_CONFIG = "${configHome}/docker";
      DOTNET_CLI_HOME = "${dataHome}/dotnet";
      GTK2_RC_FILES = "${configHome}/gtk-2.0/gtkrc";
      # does this require the directory to be made?
      XCOMPOSECACHE = "${cacheHome}/X11/xcompose";
      WINEPREFIX = "${dataHome}/wine";
      DPREFIX = "${dataHome}/darling";
      # setting this to the file directly doesn't work well on the NixOS desktop
      # environment variables don't refresh until i restart, for some reason
      PYTHONSTARTUP = "${configHome}/python/pythonrc";
      NUGET_PACKAGES = "${cacheHome}/NuGetPackages";
      LESSHISTFILE = "${stateHome}/less_history";
      SQLITE_HISTORY = "${cacheHome}/sqlite_history";
      RUSTUP_HOME = "${dataHome}/rustup";
      CARGO_HOME = "${dataHome}/cargo";
      PYENV_ROOT = "${dataHome}/pyenv";
      JUPYTER_CONFIG_DIR = "${configHome}/jupyter";
      IPYTHONDIR = "${configHome}/ipython";
      PASSWORD_STORE_DIR = "${dataHome}/pass";
      NVM_DIR = "${dataHome}/nvm";
      ANDROID_USER_HOME = "${dataHome}/android";
      BUNDLE_USER_CONFIG = "${configHome}/bundle";
      BUNDLE_USER_CACHE = "${cacheHome}/bundle";
      BUNDLE_USER_PLUGIN = "${dataHome}/bundle";
      MPLAYER_HOME = "${configHome}/mplayer";
      W3M_DIR = "${dataHome}/w3m";
      PARALLEL_HOME = "${configHome}/parallel";
    };

    file = {
      ${config.home.sessionVariables.PYTHONSTARTUP}.source = ./python-setup-history.py;
    };

    shellAliases = {
      wget = "wget --hsts-file=$XDG_DATA_HOME/wget-hsts";
    };
  };
}
