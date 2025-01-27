{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  name = "updater-thingy";
  packages = with pkgs.python3Packages; [
    python
    requests
  ];
}
