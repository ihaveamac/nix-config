{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  wrapComposerPackage,
  php,
}:

php.buildComposerProject (finalAttrs: rec {
  pname = "QRLite";
  version = "f04910ecc43f4db3b61c8c37fcca02edc18f1595";
  src = fetchFromGitHub {
    owner = "gesinn-it";
    repo = "QRLite";
    rev = version;
    hash = "sha256-Qdi+ZVUSz7jN2lHkdMrEd99dD/Zpb65D/agDGzF07sI=";
  };
  nativeBuildInputs = [ wrapComposerPackage ];
  vendorHash = "sha256-a8t6TqGK8QEXwaS6EgxJuWWp7bt3fKlsjBCiwHPf0EM=";
  composerLock = ./qrlite.lock;
  composerNoPlugins = false;
  composerStrictValidation = false;
})
