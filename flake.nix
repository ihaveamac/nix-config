{
  description = "ihaveahax's NixOS, nix-darwin and Home Manager stuff";

  nixConfig = {
    extra-substituters = [
      "https://ihaveahax.cachix.org"
      "https://attic.ihaveahax.net/ihaveahax"
    ];
    extra-trusted-public-keys = [
      "ihaveahax.cachix.org-1:587ONPwRnx0AQu27y7rD1f7jTj2isGRAVDVddKEAv7I="
      "ihaveahax:oiYXxjqHZYe4OzvX6CGFfUIK9HEZBWPS0y7DpcZ5Cok="
    ];
  };

  inputs = {
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "nix-darwin";
      # to fix some dependency of keepassxc
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    nixos-apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    hax-nur = {
      url = "github:ihaveamac/nur-packages/staging";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module?ref=refs/heads/release-2.91";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    ninfs = {
      url = "github:ihaveamac/ninfs";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    srcds-nix = {
      url = "github:ihaveamac/srcds-nix";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixos-unstable, home-manager, nixos-apple-silicon, hax-nur, lix-module, ninfs, srcds-nix }: let
    r = {
      root = ./.;
      common-nixos = ./common-nixos;
      common-home = ./common-home;
      extras = ./extras;
    };
    mkSpecialArgs = (me: system: {
      inherit me inputs r;
      my-inputs = {
        # putting this in cfg-home-manager.nix causes an infinite recursion error
        home-manager-module = if (system == "aarch64-darwin" || system == "x86_64-darwin") then
          home-manager.darwinModules.home-manager
        else
          home-manager.nixosModules.home-manager;
        hax-nur = hax-nur.outputs.packages.${system};
        ninfs = ninfs.outputs.packages.${system};
      };
    });
  in {
    darwinConfigurations = {
      # MacBook Pro
      "alphinaud" = nix-darwin.lib.darwinSystem (let
        me = "ianburgwin";
        system = "aarch64-darwin";
      in rec {
        inherit system;

        specialArgs = mkSpecialArgs me system;

        modules = [ ./nix-darwin-alphinaud/darwin-configuration.nix ];
      }); # alphinaud

      # for testing in macOS virtual machines (basically the same but lacking masapps)
      "MacVM" = nix-darwin.lib.darwinSystem (let
        me = "gordonfreeman";
        system = "aarch64-darwin";
      in rec {
        inherit system;

        specialArgs = mkSpecialArgs me system;

        modules = [
          ./nix-darwin-alphinaud/darwin-configuration.nix

          ({ lib, ... }: {
            homebrew.masApps = lib.mkForce {};
            # assuming i made my vm with "gordonfreeman"
            networking.hostName = lib.mkForce "Gordons-Virtual-Machine";
          })
        ]; # modules
      }); # MacVM

      # ADDITIONAL SYSTEMS (stuff that is not maintained as much)
      "Ians-MBP" = nix-darwin.lib.darwinSystem (let
        me = "ihaveahax";
        system = "x86_64-darwin";
      in rec {
        inherit system;

        specialArgs = mkSpecialArgs me system;

        modules = [ ./additional-systems/nix-darwin-imacbook/darwin-configuration.nix ];
      }); # Ians-MBP
    };

    nixosConfigurations = {
      "thancred" = nixos-unstable.lib.nixosSystem (let
        me = "ihaveahax";
        system = "x86_64-linux";
      in {
        inherit system;

        specialArgs = mkSpecialArgs me system;

        modules = [ ./nixos-thancred/configuration.nix ];
      }); # thancred

      "homeserver" = nixos-unstable.lib.nixosSystem (let
        me = "ihaveahax";
        system = "x86_64-linux";
      in {
        inherit system;

        specialArgs = mkSpecialArgs me system;

        modules = [ ./nixos-homeserver/configuration.nix ];
      }); # homeserver

      "tataru" = nixos-unstable.lib.nixosSystem (let
        me = "ihaveahax";
        system = "x86_64-linux";
      in {
        inherit system;

        specialArgs = mkSpecialArgs me system;

        modules = [ ./nixos-tataru/configuration.nix ];
      }); # tataru

      # ADDITIONAL SYSTEMS (stuff that is not maintained as much)

      "asahinix" = nixos-unstable.lib.nixosSystem (let
        me = "ihaveahax";
        system = "aarch64-linux";
      in {
        inherit system;

        specialArgs = mkSpecialArgs me system;

        modules = [ ./additional-systems/nixos-asahinix/configuration.nix ];
      }); # asahinix

      "imacbooknix" = nixos-unstable.lib.nixosSystem (let
        me = "ihaveahax";
        system = "x86_64-linux";
      in {
        inherit system;

        specialArgs = mkSpecialArgs me system;

        modules = [ ./additional-systems/nixos-imacbooknix/configuration.nix ];
      }); # imacbooknix

      "liveimage" = nixos-unstable.lib.nixosSystem (let
        me = "nixos";
        system = "x86_64-linux";
      in {
        inherit system;

        specialArgs = mkSpecialArgs me system;

        modules = [
          ./additional-systems/nixos-liveimage/configuration.nix
          { environment.etc."nix-config".source = self; }
        ];
      }); # liveimage
    }; # nixosConfigurations

    homeConfigurations = {
      # Steam Deck (SteamOS)
      "deck@krile" = home-manager.lib.homeManagerConfiguration (let
        system = "x86_64-linux";
        pkgs = import nixos-unstable { inherit system; };
      in {
        inherit pkgs;

        extraSpecialArgs = mkSpecialArgs "deck" system;

        modules = [ ./hm-krile/home.nix ];
      });
    }; # homeConfigurations

    devShells.x86_64-linux.default = import ./shell.nix { pkgs = import nixos-unstable { system = "x86_64-linux"; }; };

    packages = let
      # this is a derivation in part so i can easily nix-copy-closure this
      # in case i need to, which there was at least one time i did...
      buildInputs = p: p.stdenvNoCC.mkDerivation {
        name = "flake-inputs";

        dontUnpack = true;
        dontPatch = true;
        dontUpdateAutotoolsGnuConfigScripts = true;
        dontConfigure = true;
        dontBuild = true;
        dontFixup = true;

        installPhase = ''
          echo testing
          mkdir $out
        '' + p.lib.concatStringsSep "\n" (p.lib.mapAttrsToList (k: v: ''
          echo "Linking input ${k}"
          ln -s ${v} $out/${k}
        '') {
          "hax-nur" = hax-nur;
          "hax-nur.nixpkgs" = hax-nur.inputs.nixpkgs;
          "home-manager" = home-manager;
          "home-manager.inputs.nixpkgs" = home-manager.inputs.nixpkgs;
          "lix-module" = lix-module;
          "lix-module.flake-utils" = lix-module.inputs.flake-utils;
          "lix-module.flake-utils.systems" = lix-module.inputs.flake-utils.inputs.systems;
          "lix-module.flakey-profile" = lix-module.inputs.flakey-profile;
          "lix-module.lix" = lix-module.inputs.lix;
          "lix-module.nixpkgs" = lix-module.inputs.nixpkgs;
          "ninfs" = ninfs;
          "ninfs.flake-utils" = ninfs.inputs.flake-utils;
          "ninfs.flake-utils.systems" = ninfs.inputs.flake-utils.inputs.systems;
          "ninfs.nixpkgs" = ninfs.inputs.nixpkgs;
          "ninfs.pyctr" = ninfs.inputs.pyctr;
          "ninfs.pyctr.nixpkgs" = ninfs.inputs.pyctr.inputs.nixpkgs;
          "nix-darwin" = nix-darwin;
          "nix-darwin.nixpkgs" = nix-darwin.inputs.nixpkgs;
          "nixos-apple-silicon" = nixos-apple-silicon;
          "nixos-apple-silicon.flake-compat" = nixos-apple-silicon.inputs.flake-compat;
          "nixos-apple-silicon.nixpkgs" = nixos-apple-silicon.inputs.nixpkgs;
          "nixos-apple-silicon.rust-overlay" = nixos-apple-silicon.inputs.rust-overlay;
          "nixos-unstable" = nixos-unstable;
          "srcds-nix" = srcds-nix;
          "srcds-nix.nixpkgs" = srcds-nix.inputs.nixpkgs;
        });
      };
    in {
      x86_64-linux = let 
        pkgs = import nixos-unstable { system = "x86_64-linux"; };
      in rec {
        default = all-systems;
        flake-inputs = buildInputs pkgs;
        all-systems = pkgs.stdenvNoCC.mkDerivation {
          name = "all-systems-x86_64-linux";

          dontUnpack = true;
          dontPatch = true;
          dontUpdateAutotoolsGnuConfigScripts = true;
          dontConfigure = true;
          dontBuild = true;
          dontFixup = true;

          installPhase = ''
            mkdir $out

            ln -s ${pkgs.lib.info "evaluating thancred" self.nixosConfigurations.thancred.config.system.build.toplevel} $out/nixos-thancred
            ln -s ${pkgs.lib.info "evaluating tataru" self.nixosConfigurations.tataru.config.system.build.toplevel} $out/nixos-tataru
            ln -s ${pkgs.lib.info "evaluating homeserver" self.nixosConfigurations.homeserver.config.system.build.toplevel} $out/nixos-homeserver

            ln -s ${pkgs.lib.info "evaluating hm-krile" self.homeConfigurations."deck@krile".activationPackage} $out/hm-krile

            ln -s ${flake-inputs} $out/.flake-inputs
          '';
        };
        iso = let
          system = self.nixosConfigurations.liveimage;
          isobase = system.config.system.build.isoImage;
        in pkgs.stdenvNoCC.mkDerivation {
          name = (isobase.name + "-static-name");

          dontUnpack = true;
          dontPatch = true;
          dontUpdateAutotoolsGnuConfigScripts = true;
          dontConfigure = true;
          dontBuild = true;
          dontFixup = true;

          installPhase = ''
            mkdir $out
            isoname=${isobase}/iso/${isobase.name}
            ln -s $isoname $out/nixos.iso
            cat >$out/copy-to-thancred.sh <<EOF
            ${pkgs.rsync}/bin/rsync -avzLI --progress $isoname thancred:nixos.iso
            EOF

            cat >$out/copy-to-macbook.sh <<EOF
            ${pkgs.rsync}/bin/rsync -avzLI --progress $isoname alphinaud:nixos.iso
            EOF

            cat >$out/copy-to-libvirt-images.sh <<EOF
            sudo cp -v $isoname /var/lib/libvirt/images
            EOF

            chmod +x $out/*.sh
          '';
        };
      };

      aarch64-darwin = let
        pkgs = import nixos-unstable { system = "aarch64-darwin"; };
      in rec {
        default = all-systems;
        flake-inputs = buildInputs pkgs;
        all-systems = pkgs.stdenvNoCC.mkDerivation {
          name = "all-systems-aarch64-darwin";

          dontUnpack = true;
          dontPatch = true;
          dontUpdateAutotoolsGnuConfigScripts = true;
          dontConfigure = true;
          dontBuild = true;
          dontFixup = true;

          installPhase = ''
            mkdir $out

            ln -s ${self.darwinConfigurations.alphinaud.system} $out/nix-darwin-alphinaud

            ln -s ${flake-inputs} $out/.flake-inputs
          '';
        };
      };
    };
  };
}
