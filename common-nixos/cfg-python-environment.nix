{ config, lib, pkgs, ... }:

# I know including python3 directly in a NixOS system PATH is less ideal,
# but I use it really often, so I want easy access to it
# like it says in nixpkgs, optimizations are off by default since it is not reproducible
# but this is not an issue for me, so i'll take the faster python
let
  mkPythonEnv = (pythonPackages: packages: overrides: ( pythonPackages.python.override { enableOptimizations = true; stripBytecode = false; } // overrides ).buildEnv.override {
    extraLibs = packages pythonPackages;
    ignoreCollisions = true;
  });
in
{
  # this would add the multiple environments to every system,
  # i only really need this on thancred, but i'll maybe figure it out later...
  environment.systemPackages = [
    (mkPythonEnv pkgs.python312Packages (p: [ p.requests ]) {})
    (mkPythonEnv pkgs.python313Packages (p: [ p.requests ]) {})
    # python314Packages.requests has failing dependencies
    (mkPythonEnv pkgs.python314Packages (p: []) {})
  ];
}
