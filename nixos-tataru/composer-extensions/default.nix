{
  pkgs ? import <nixpkgs> { },
}:

let
  inherit (pkgs) fetchFromGitHub;
  getWMExtension = import ../func-get-wm-extension.nix { inherit pkgs; };
  wrapComposerPackage = pkgs.callPackage ./wrap-composer-package.nix { };
  mkExtensionWithComposer = file: pkgs.callPackage file { inherit wrapComposerPackage; };
  mkMWExtension =
    {
      pname,
      src,
      vendorHash,
      composerLock,
      branch ? null,
    }:
    pkgs.callPackage ./func-mk-mediawiki-extension.nix {
      inherit
        pname
        src
        vendorHash
        composerLock
        branch
        ;
    };
in
{
  QRLite = mkMWExtension {
    pname = "QRLite";
    src = fetchFromGitHub {
      owner = "gesinn-it";
      repo = "QRLite";
      rev = "f04910ecc43f4db3b61c8c37fcca02edc18f1595";
      hash = "sha256-Qdi+ZVUSz7jN2lHkdMrEd99dD/Zpb65D/agDGzF07sI=";
    };
    branch = "master";
    vendorHash = "sha256-kBDrebeeqw/k13H/yewxDNbf4Rah8lucmC8WI1G6TmE=";
    composerLock = ./qrlite.lock;
  };
  TemplateStyles = mkMWExtension rec {
    pname = "TemplateStyles";
    src = getWMExtension {
      name = pname;
      rev = "ed31fd5b2cc7f0de7b2b4082b67cdc68d2f5df59";
      hash = "sha256-Q7wjabC1EahpOAKmGXDU3m/X2lYgVUjbAuuSK+t/LO8=";
    };
    vendorHash = "sha256-K6hWWEIh0lfxOB6hIn+M5YtBVf5k8Q840TopJMq5gB8=";
    composerLock = ./templatestyles.lock;
  };
  Variables = mkMWExtension rec {
    pname = "Variables";
    src = getWMExtension {
      name = pname;
      rev = "c1dea981c86b4077a82cfa15fe404006e9aeb045";
      hash = "sha256-S2hgKLfIg/DdNSGSouJIqJVPFlxI0iUzrSncGLPMaII=";
    };
    vendorHash = "sha256-gJO+FBauSID98XvOVW0Q/E31LRj8Fxv4ly/jDLOJih4=";
    composerLock = ./variables.lock;
  };
}
