{
  php,
  lib,
  stdenvNoCC,
  src,
  pname,
  version,
  vendorHash ? lib.fakeHash,
  composerLock ? null
}:

let
  wrapped-extension = php.buildComposerProject (finalAttrs: rec {
    inherit pname version src vendorHash composerLock;
    composerNoPlugins = false;
    composerStrictValidation = false;
  });
in
stdenvNoCC.mkDerivation rec {
  pname = "wrapped-mediawiki-extension-" + wrapped-extension.pname;
  version = wrapped-extension.version;
  dontUnpack = true;
  installPhase = ''
    set -x
    mkdir $out
    find -L ${wrapped-extension}/share/php/${wrapped-extension.pname} -maxdepth 1 -print0 | while read -d $'\0' f; do
      ln -s "$f" $out/$(basename "$f")
    done
    set +x
  '';
}
