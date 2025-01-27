{
  config,
  lib,
  pkgs,
  r,
  osConfig,
  ...
}:

{
  imports = [
    (r.common-home + /cfg-docker-aliases.nix)
  ];

  fonts.fontconfig.enable = lib.mkForce false;

  # don't like having this over system man on mac
  programs = {
    man.enable = false;
    ssh.extraOptionOverrides = {
      UseKeychain = "yes";
    };
    zsh = {
      oh-my-zsh.plugins = [
        "macos"
        #"macports"
        "brew"
      ];
      shellAliases = {
        uq = "/usr/bin/xattr -r -d com.apple.quarantine";
      };
      envExtra = ''
        ######################################################################
        # begin nix-darwin-imacbook/home.nix

        export CROOTS="$HOME/Library/CustomRoots"
        export CGENERIC="$CROOTS/Generic"

        export PATH="$CGENERIC/bin:$PATH"

        # end nix-darwin-macbook/home.nix
      '';
      initExtra = ''
        ######################################################################
        # begin nix-darwin-macbook/home.nix

        # end nix-darwin-macbook/home.nix
      '';
    };
  };

  targets.darwin.defaults = {
    "com.apple.dock" = {
      # 53 is what i had it for a while
      # 50 will fit 6 recent apps on the default resolution on the macbook
      tilesize = 50;
      mru-spaces = false;
      expose-group-apps = false;
      size-immutable = true;
    };
    "com.apple.finder" = {
      _FXShowPosixPathInTitle = false;
      _FXSortFoldersFirst = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      QuitMenuItem = false;
      # list view
      FXPreferredViewStyle = "Nlsv";
      # use previous scope
      FXDefaultSearchScope = "SCsp";
      ShowHardDrivesOnDesktop = false;
    };
    "com.apple.WindowManager" = {
      EnableStandardClickToShowDesktop = 0;
    };
    "com.apple.universalaccess" = {
      showWindowTitlebarIcons = true;
      showToolbarButtonShapes = true;
    };
    "com.jetbrains.pycharm" = {
      # allow repeating keys in PyCharm
      ApplePressAndHoldEnabled = false;
    };
    "com.googlecode.iterm2" = {
      # allow repeating keys in iTerm2
      ApplePressAndHoldEnabled = false;
      # if nix managed: false
      # otherwise: true
      SUEnableAutomaticChecks = true;
    };
    "com.apple.Safari" = {
      AutoOpenSafeDownloads = false;
      IncludeDevelopMenu = true;
    };
    "com.apple.desktopservices" = {
      # https://support.apple.com/en-us/HT208209
      DSDontWriteNetworkStores = true;
    };
    "com.apple.DiskUtility" = {
      SidebarShowAllDevices = true;
    };
    "NSGlobalDomain" = {
      AppleAccentColor = 5;
      AppleHighlightColor = "0.968627 0.831373 1.000000 Purple";
      NSAutomaticDashSubstitutionEnabled = false;
      AppleShowScrollBars = "WhenScrolling";
      # this is meant to go here and not finder's prefs
      AppleShowAllExtensions = true;
      # fourth notch of 10
      "com.apple.trackpad.scaling" = "0.6875";
      # disable Natural Scrolling
      # 0 seems to disable it, but sometimes it seems to reset
      # having this here seems to make it act weird
      #"com.apple.swipescrolldirection" = 0;
    };
  };

  home.packages = with pkgs; [
    hax._3dstool
    hax.save3ds
    hax.ctrtool
    hax.makerom
    gource
    (armips.override { stdenv = pkgs.clangStdenv; })
    (pkgs.writeShellScriptBin "reload-finder-and-dock" ''
      # in case Finder and Dock settings are updated
      killall Finder
      killall Dock
    '')
  ];
}
