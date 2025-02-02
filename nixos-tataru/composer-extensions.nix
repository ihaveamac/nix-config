{ pkgs ? import <nixpkgs> {} }:

let
  wrapComposerPackage = pkgs.callPackage ./wrap-composer-package.nix {};
  mkExtensionWithComposer = file: pkgs.callPackage file { inherit wrapComposerPackage; };
in
{
  QRLite = mkExtensionWithComposer ./deriv-qrlite.nix;
}
