{
  lib,
  stdenvNoCC,
  callPackage,
  system,
  flakeConfigurations,
  flakeInputs,
}:

let
  flake-inputs-deriv = callPackage ./deriv-flake-inputs.nix { inherit flakeInputs; };
in
stdenvNoCC.mkDerivation {
  name = "all-systems-${system}";

  dontUnpack = true;
  dontPatch = true;
  dontUpdateAutotoolsGnuConfigScripts = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  passthru = { inherit flake-inputs-deriv; };

  installPhase =
    ''
      mkdir $out
      ln -s ${lib.warn "evaluating flake inputs" flake-inputs-deriv} $out/.flake-inputs
    ''
    + lib.concatStringsSep "\n" (
      lib.mapAttrsToList (k: v: "ln -s ${lib.warn "evaluating ${k}" v} $out/${k}") flakeConfigurations
    );
}
