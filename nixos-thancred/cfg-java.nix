{
  config,
  lib,
  pkgs,
  ...
}:

let
  javas = {
    jdk8 = pkgs.jdk8;
    jdk17 = pkgs.jdk17;
    jdk21 = pkgs.jdk21;
  };
  java-container = pkgs.stdenvNoCC.mkDerivation {
    name = "javas-mostly-for-minecraft";
    dontUnpack = true;

    buildPhase =
      ''
        OUTDIR=$out/share/javas
        mkdir -p $OUTDIR
      ''
      + (lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: jdk: "ln -s ${jdk} $OUTDIR/${name}") javas
      ));
  };
in
{
  environment.systemPackages = [ java-container ];
}
