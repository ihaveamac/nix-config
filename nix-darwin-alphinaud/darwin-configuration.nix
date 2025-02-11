# TO ACTIVATE ON A NEW MAC:
# * make sure to update "me"
# * make sure Terminal has permission to modify other apps (or grant it full disk access)
# * install Command Line Tools + brew
# * install Rosetta 2: softwareupdate --install-rosetta
# * set system security to Reduced Security + user management of kernel extensions
# * install macfuse through brew first (or save3ds will fail)
# * in etc, move nix/nix.conf, zprofile, zshenv, and zshrc out of the way
# maybe i should do a script for this

{
  config,
  pkgs,
  lib,
  me,
  r,
  inputs,
  ...
}:

let
  myjava = pkgs.zulu21;
in
{
  imports = [
    (r.common-nixos + /cfg-sudo-config.nix)
    (r.common-nixos + /cfg-nix-homeserver-builder.nix)
    (r.common-nixos + /cfg-nix-settings.nix)
    (r.common-nixos + /cfg-home-manager.nix)
    (r.extras + /shared-nix-settings.nix)
    ./cfg-homebrew.nix
    ./cfg-masapps.nix
    ./cfg-jvms.nix
    #./cfg-linux-builder.nix
    ./cfg-applinker.nix
    ./cfg-persistent-apps.nix

    inputs.hax-nur.nixosModules.overlay
    inputs.lix-module.nixosModules.default
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    vim
    myjava # also update JAVA_HOME
    powershell
    # singleBinary is false since symlinks doesn't work with withPrefix, and shebangs starts a shell (this is probably an unnecessary fear)
    (coreutils-full.override {
      withPrefix = true;
      singleBinary = false;
    })
    qemu
    squashfuse
    (p7zip.override { enableUnfree = true; })
    (_7zz.override { enableUnfree = true; })
    btop
    smartmontools
    sops
  ];

  environment.variables = {
    MANPATH = "/opt/homebrew/share/man\${MANPATH+:$MANPATH}:";
    PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/zfs/bin\${PATH+:$PATH}";
    INFOPATH = "/opt/homebrew/share/info:\${INFOPATH:-}";
    HOMEBREW_PREFIX = "/opt/homebrew";
    HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
    HOMEBREW_REPOSITORY = "/opt/homebrew";
    JAVA_HOME = "${myjava}/Contents/Home";
    PKG_CONFIG_PATH = "/opt/homebrew/lib/pkgconfig:/usr/local/lib/pkgconfig";
    # this fixed building rust crates that use the fuser crate for x86_64 while on arm64
    PKG_CONFIG_SYSROOT_DIR = "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk";
    ZDOTDIR = "$HOME/.config/zsh"; # so hopefully i can remove ~/.zshenv
    NIXPKGS_CONFIG = "/etc/nix/nixpkgs-config.nix";
  };
  # "launchd.user.envVariables" does not work after a reboot...

  environment.shells = with pkgs; [ zsh ];

  # https://github.com/LnL7/nix-darwin/issues/784
  environment.etc."pam.d/sudo_local" = {
    text = "auth       sufficient     pam_tid.so";
  };

  environment.extraInit = ''
    # special case for free-threading python
    for v in 3.{14,13}; do
      export PATH="/Library/Frameworks/PythonT.framework/Versions/$v/bin:$PATH"
      export PKG_CONFIG_PATH="/Library/Frameworks/PythonT.framework/Versions/$v/lib/pkgconfig:$PKG_CONFIG_PATH"
    done

    # this puts it in reverse order, basically the first one will be the last to be searched
    # that's where i wanna put pre-release versions of python
    for v in 3.{14,8,9,10,11,12,13}; do
      export PATH="$HOME/Library/Python/$v/bin:$PATH"
      export PATH="/Library/Frameworks/Python.framework/Versions/$v/bin:$PATH"
      export PKG_CONFIG_PATH="/Library/Frameworks/Python.framework/Versions/$v/lib/pkgconfig:$PKG_CONFIG_PATH"
    done
  '';

  nix = {
    # the other settings are in common-nixos/cfg-nix-settings.nix
    settings = {
      extra-nix-path = [ "nixpkgs=flake:nixpkgs" ];
    };
    optimise = {
      automatic = true;
      interval = [
        {
          Hour = 4;
          Minute = 0;
        }
      ];
    };
  };

  # defaults activation issue: https://github.com/LnL7/nix-darwin/issues/658
  # activation scripts issue: https://github.com/LnL7/nix-darwin/issues/663
  system.activationScripts.postUserActivation.text = ''
    echo calling activateSettings...
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

  system.darwinLabel =
    let
      cfg = config.system;
    in
    "${config.networking.hostName}-${cfg.nixpkgsVersion}+${cfg.darwinVersion}";

  networking.hostName = "alphinaud";

  users.users.${me} = {
    name = "${me}";
    home = "/Users/${me}";
    shell = pkgs.zsh; # doesn't work yet: https://github.com/LnL7/nix-darwin/issues/811
    openssh.authorizedKeys.keyFiles = [ (r.extras + /id_rsa.pub) ];
  };

  users.users.root = {
    home = "/var/root";
    shell = pkgs.zsh; # doesn't work yet: https://github.com/LnL7/nix-darwin/issues/811
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.bash = {
    enable = true;
    interactiveShellInit = ''
      # same as common-nixos/cfg-xdg.nix
      export HISTFILE=$XDG_STATE_HOME/bash_history
    '';
  };
  programs.zsh = {
    enable = true; # default shell on catalina
  };

  # since ZDOTDIR is set globally, i don't need this useless .zshenv file (hopefully)
  home-manager.users.root.home.file.".zshenv".enable = false;
  home-manager.users.${me} = {
    imports = [ ./home.nix ];
    home.file.".zshenv".enable = false;
  };

  programs.tmux.enable = true;

  services.tailscale.enable = true;

  system.systemBuilderCommands = ''
    cat > $out/hax-switch-config <<EOF
    #! ${pkgs.bash}/bin/bash
    sudo nix-env -p /nix/var/nix/profiles/system --set $out
    $out/activate-user
    sudo $out/activate
    EOF
    chmod +x $out/hax-switch-config
  '';

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
