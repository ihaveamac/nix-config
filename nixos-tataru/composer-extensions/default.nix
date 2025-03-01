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
      rev = "fa2a9473eea9918545879901faf628d17fd4d48a";
      hash = "sha256-kwe41Ix/GHbGiFUCXQGEjdmhzGuUoRQgj3UGCRIV7NA=";
    };
    vendorHash = "sha256-fS2NnHtVldDoUCMwo2ujTNUzTt/KTt6YEeWjXLPn6eg=";
    composerLock = ./templatestyles.lock;
  };
  Variables = mkMWExtension rec {
    pname = "Variables";
    src = getWMExtension {
      name = pname;
      rev = "81115fae09d0a219078d2a2511de83474fd2eb8f";
      hash = "sha256-DZfd/ip/i9QneO6rgCD8dhriW0Kld2Prz/Ve7eo8dhY=";
    };
    vendorHash = "sha256-tCCy6pxO8+agiOWr1zEtG5Uq97iCHNF0RgLJL2iigDM=";
    composerLock = ./variables.lock;
  };
}
