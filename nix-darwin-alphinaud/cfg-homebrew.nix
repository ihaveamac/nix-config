{ ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
      extraFlags = [ "--verbose" ];
    };
    caskArgs = {
      no_quarantine = true;
    };
    brews = [
      "unxip"
      #"binutils"
      #"coreutils"
      #"gnu-tar"

      # having these around makes it easier to build stuff outside of nix
      "cmake"
      "pkg-config"

      # for building Python outside nix
      "openssl@3.0"
      "xz"
      "gdbm"
      "tcl-tk"
    ];
    taps = [ "macos-fuse-t/cask" ];
    casks =
      [
        # auto updates
        "default-folder-x"
        "micro-snitch"
        "jettison"
        "soundsource"
        "transmit"
        "altserver"
        #"bettertouchtool"
        "firefox"
        "discord"
        "imazing"
        "whatsapp"
        "crossover"
        "vmware-fusion"
        "bartender"
        "telegram"
        "handbrake"
        #"linearmouse"
        #"little-snitch"
        "istat-menus"
        "steam"
        "macfuse"
        "vimr" # neovim but gui
        "xiv-on-mac"
        "nextcloud"
        "signal"
        "iterm2"

        # no auto updates
        # CU: checks for updates but doesn't auto-download
        "app-tamer" # CU
        "db-browser-for-sqlite"
        "eaglefiler"
        "foobar2000"
        #"ios-app-signer"
        #"keepassxc" # CU
        "libreoffice" # CU
        "mullvadvpn" # CU
        "suspicious-package" # CU
        #"yubico-yubikey-manager"
        "openzfs"
        "xquartz"
        "syncplay" # this one is in nixpkgs but does not create an "Applications" folder

        # quicklook plugins
        "qlstephen"
        "qlmarkdown"

        "font-sf-compact"
        "font-sf-mono"
        "font-sf-pro"
        "font-new-york"
        # for powerlevel10k
        #"font-meslo-for-powerline"
        #"font-sf-mono-for-powerline"
        "macos-fuse-t/cask/fuse-t"
      ]
      ++ (map
        (pkg: {
          name = pkg;
          greedy = true;
        })
        [
          # stuff that can self-update but that i still want brew to update
          "coteditor"
          "launchcontrol"
          "betterzip"
          "nova"
          "transmission"
          "qbittorrent"
          "daisydisk"
          "wordpresscom"
          #"playcover-community"
          "vlc"
          #"appcleaner"
          "textual"
          "sf-symbols"
          "element"
          "prefs-editor"
          "minecraft"
        ]
      );
  };
}
