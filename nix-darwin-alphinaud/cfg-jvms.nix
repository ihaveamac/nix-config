{ config, pkgs, lib, ... }:

let
  jvms = pkgs.stdenvNoCC.mkDerivation {
    name = "java-virtual-machines";
    dontUnpack = true;
    buildInputs = with pkgs; [ zulu21 zulu17 zulu8 ];

    buildPhase = ''
      mkdir $out
      for f in $buildInputs; do
        #echo $f >> $out/inputs.txt
        #ls -l $f >> $out/inputs.txt
        #echo >> $out/inputs.txt

        for jdk in $f/*.jdk; do
          echo "linking $jdk"
          ln -s $jdk $out/
        done
      done
    '';
  };
in
{
  # basically a copy of this:
  # https://github.com/LnL7/nix-darwin/blob/f0dd0838c3558b59dc3b726d8ab89f5b5e35c297/modules/system/applications.nix

  system.activationScripts.postActivation.text = ''
    # Set up JavaVirtualMachines.
    echo "setting up /Library/Java/JavaVirtualMachines..." >&2

    ourLink () {
      local link
      link=$(readlink "$1")
      [ -L "$1" ] && [ "''${link#*-}" = 'java-virtual-machines' ]
    }

    removeIfNotLink () {
      test -L "$1"
      isnotlink=$?
      echo "isnotlink: $isnotlink"
      if [ "$isnotlink" = "1" ]; then
        echo "would remove";
        rmdir "$1"
        return $?
      fi
    }

    if [ ! -e '/Library/Java/JavaVirtualMachines' ] \
       || ourLink '/Library/Java/JavaVirtualMachines' \
       || removeIfNotLink /Library/Java/JavaVirtualMachines; then
      ln -sfn ${jvms} '/Library/Java/JavaVirtualMachines'
    else
      echo "warning: /Library/Java/JavaVirtualMachines is not owned by nix-darwin, skipping JVM linking..." >&2
    fi
  '';
}
