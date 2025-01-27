{
  config,
  lib,
  pkgs,
  ...
}:

{
  # i want to use a custom script to make this happen
  home.file."Applications/Home Manager Apps".enable = false;

  home.activation.link-apps = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # Set up applications but better.

    appDirPath="${config.home.homeDirectory}/Applications/Home Manager Apps"
    echo "setting up ''${appDirPath}..."

    tempPath=$(mktemp -d)
    chmod 755 "$tempPath"

    # "find" is used here because "*.app" will not work properly if there are no apps, so it returns "*.app" literally
    find -L "${
      config.home.file."Applications/Home Manager Apps".source
    }" -maxdepth 1 -type d -iname '*.app' -print0 | while read -r -d $'\0' app; do
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
      oldAppDirDest=$(mktemp -d --suffix=-OldHomeManagerApps)
      chmod 700 "$oldAppDirDest"
      echo "moving old path to $oldAppDirDest"
      mv "$appDirPath" "$oldAppDirDest"
    fi
    mv "$tempPath" "$appDirPath"
  '';
}
