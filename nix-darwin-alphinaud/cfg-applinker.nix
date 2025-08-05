{
  config,
  lib,
  pkgs,
  my-inputs,
  ...
}:

{
  nixpkgs.config.allowUnsupportedSystem = true;
  environment.systemPackages = with pkgs; [
    # gpgme marked as broken, also i use strongbox now
    #keepassxc
    iina
    # sfml build error
    #dolphin-emu
    utm
    prismlauncher
    #qbittorrent
    (hexfiend.overrideAttrs (oldAttrs: {
      installPhase =
        oldAttrs.installPhase
        + ''

          mkdir -p $out/bin
          ln -s "$out/Applications/Hex Fiend.app/Contents/Resources/hexf" $out/bin/hexf
        '';
    }))
    localsend
    # TODO: https://github.com/NixOS/nixpkgs/issues/428792
    #audacity
    (feishin.override { electron_31 = electron_32; })
  ];
  system.activationScripts.applications.text = lib.mkForce ''
    # Set up applications but better.

    appDirPath="/Applications/Nix Apps"
    echo "setting up ''${appDirPath}..."

    tempPath=$(mktemp -d)
    chmod 755 "$tempPath"

    # "find" is used here because "*.app" will not work properly if there are no apps, so it returns "*.app" literally
    find -L "${config.system.build.applications}/Applications" -maxdepth 1 -type d -iname '*.app' -print0 | while read -r -d $'\0' app; do
      echo " - $app"
      appName=$(basename "$app")
      outAppPath="$tempPath/$appName"
      mkdir "$outAppPath"
      chmod 755 "$outAppPath"
      realPath=$(readlink -f "$app")
      ln -s "$realPath/Contents" "$outAppPath/Contents"
    done

    #echo "LOOK AT ME: $tempPath"

    if [ -d "$appDirPath" ]; then
      oldAppDirDest=$(mktemp -d --suffix=-OldNixApps)
      chmod 755 "$oldAppDirDest"
      echo "moving old path to $oldAppDirDest"
      mv "$appDirPath" "$oldAppDirDest"
    fi
    mv "$tempPath" "$appDirPath"
  '';
}
