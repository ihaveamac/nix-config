{
  config,
  lib,
  pkgs,
  r,
  my-inputs,
  osConfig,
  ...
}:

let
  nix-channel-and-index-update = pkgs.writeShellApplication {
    name = "nix-channel-and-index-update";
    runtimeInputs = with pkgs; [
      nix-index
      osConfig.nix.package
    ];
    text = ''
      set -x
      nix-channel --update
      nix-index
    '';
  };
in
{
  imports = [
    (r.common-home + /desktop.nix)
    (r.common-home + /core.nix)
    (r.common-home + /cfg-docker-aliases.nix)
    ./cfg-home-applinker.nix
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
        # begin nix-darwin-alphinaud/home.nix

        # prevent setting it twice in deeper shells
        #if [ -n "$OLD_PKG_CONFIG_PATH" ]; then
        #  OLD_PKG_CONFIG_PATH="$PKG_CONFIG_PATH"
        #else
        #  PKG_CONFIG_PATH="$OLD_PKG_CONFIG_PATH"
        #fi

        export CROOTS="$HOME/Library/CustomRoots"
        export CGENERIC="$CROOTS/Generic"

        export PATH="$HOME/Library/Application Support/JetBrains/Toolbox/scripts:$PATH"

        export PATH="$CARGO_HOME/bin:$PATH"

        export PATH="$CGENERIC/bin:$PATH"

        if [ -n "$DEVKITPRO" ]; then
          export PATH="$DEVKITPRO/tools/bin:$PATH"

          # rust3ds wants this wtf
          export PATH="$DEVKITARM/bin:$PATH"
        fi

        # end nix-darwin-alphinaud/home.nix
      '';
      initContent = ''
        ######################################################################
        # begin nix-darwin-alphinaud/home.nix

        LOCALCOLOR=$'%{\e[1;34m%}'
        #PS1=$'[%{\e[1;34m%}%n@%m%{\e[0m%} %c]%% ';

        # end nix-darwin-alphinaud/home.nix
      '';
    };
    vifm.extraConfig = ''
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " begin nix-darwin-alphinaud/home.nix

      " Nintendo 3DS types
      "fileviewer {*.cia}
      "        \ ctrtool/bin/ctrtool -t cia %f
      "fileviewer {*.3ds,*.cci}
      "        \ ctrtool/bin/ctrtool -t ncsd %f
      "fileviewer {*.3ds,*.cci}
      "        \ ctrtool/bin/ctrtool -t ncsd %f

      " end nix-darwin-alphinaud/home.nix
    '';
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

  launchd.agents."local.nix-channel-and-index-update" = {
    enable = true;
    config = {
      Label = "local.nix-channel-and-index-update";
      LowPriorityIO = true;
      ProcessType = "Background";
      Program = "${nix-channel-and-index-update}/bin/nix-channel-and-index-update";
      StartCalendarInterval = [
        {
          Hour = 12;
          Minute = 0;
          #Weekday = 0;
        }
      ];
      StandardErrorPath = "/tmp/local.nix-channel-and-index-update.stderr";
      StandardOutPath = "/tmp/local.nix-channel-and-index-update.stdout";
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
