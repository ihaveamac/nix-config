{ pkgs, inputs }:

# this is to be set as a NIXPKGS_CONFIG env var
# but this should also go in /etc or something
''
  {
    allowUnfree = true;

    packageOverrides = pkgs: {
      hax = import ${inputs.hax-nur} { inherit pkgs; };
    };
  }
''
