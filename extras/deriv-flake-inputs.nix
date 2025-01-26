{
  lib,
  stdenvNoCC,
  flakeInputs,
}:

let
  flattenInputsAttrs =
    with lib;
    pfx: attrs:
    (flatten (
      mapAttrsToList (
        k: v:
        if k == "self" then
          [ ]
        else
          let
            subInputs = v.inputs or null;
          in
          [
            {
              name = "${pfx}${k}";
              value = v.outPath;
            }
          ]
          ++ (optional (subInputs != null) (flattenInputsAttrs "${pfx}${k}." subInputs))
      ) attrs
    ));
  inputsAttrs = lib.listToAttrs (flattenInputsAttrs "" flakeInputs);
in
stdenvNoCC.mkDerivation {
  name = "flake-inputs";

  dontUnpack = true;
  dontPatch = true;
  dontUpdateAutotoolsGnuConfigScripts = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  passthru.inputsAttrs = inputsAttrs;

  installPhase =
    ''
      mkdir $out
    ''
    + lib.concatStringsSep "\n" (
      lib.mapAttrsToList (k: v: ''
        echo "Linking input ${k}"
        ln -s ${v} $out/${k}
      '') inputsAttrs
    );
}
