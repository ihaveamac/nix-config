{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  wrapComposerPackage,
  php,
}:

php.buildComposerProject (finalAttrs: rec {
  pname = "QRLite";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "gesinn-it";
    repo = "QRLite";
    rev = "f04910ecc43f4db3b61c8c37fcca02edc18f1595";
    hash = "sha256-Qdi+ZVUSz7jN2lHkdMrEd99dD/Zpb65D/agDGzF07sI=";
  };
  nativeBuildInputs = [ wrapComposerPackage ];
  vendorHash = "sha256-kBDrebeeqw/k13H/yewxDNbf4Rah8lucmC8WI1G6TmE=";
  composerLock = ./qrlite.lock;
  composerNoDev = true;
  composerNoPlugins = false;
  composerStrictValidation = false;
})
