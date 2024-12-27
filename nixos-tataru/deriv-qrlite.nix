{ lib, stdenvNoCC, fetchFromGitHub, wrapComposerPackage, php }:

php.buildComposerProject (finalAttrs: rec {
  pname = "QRLite";
  version = "1.0.0-alpha3";
  src = fetchFromGitHub {
    owner = "gesinn-it";
    repo = "QRLite";
    rev = version;
    hash = "sha256-Edz2vPJuMnYY2pPQsxyc8Qj8FCOTnV1/oE32949jiKw=";
  };
  nativeBuildInputs = [ wrapComposerPackage ];
  vendorHash = "sha256-a8t6TqGK8QEXwaS6EgxJuWWp7bt3fKlsjBCiwHPf0EM=";
  composerLock = ./qrlite.lock;
  composerNoPlugins = false;
  composerStrictValidation = false;
})
