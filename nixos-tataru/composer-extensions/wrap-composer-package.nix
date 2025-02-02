{ makeSetupHook }:

makeSetupHook {
  name = "wrap-composer-package";
} ./wrap-composer-package.sh

#unwrapped: stdenvNoCC.mkDerivation rec {
#  pname = "mediawiki-wrapped-extension-" + unwrapped.name;
#  version = unwrapped.version;
#
#  dontUnpack = true;
#
#  installPhase = ''
#    mkdir $out
#    find -L ${unwrapped}/share/php/${unwrapped.pname} -maxdepth 1 -print0 | while read -d $'\0' f; do
#      ln -s "$f" $out/$(basename "$f")
#    done
#  '';
#
#  passthru = {
#    # for nix-update
#    composerRepository = unwrapped.composerRepository;
#  };
#}
