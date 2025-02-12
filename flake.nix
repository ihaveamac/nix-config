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
    # TODO: switch back after this is merged:
    # https://nixpk.gs/pr-tracker.html?pr=372458
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";
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
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
    hax-nur = {
      url = "github:ihaveamac/nur-packages/staging";
      inputs.nixpkgs.follows = "nixos-unstable";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module?ref=refs/heads/release-2.92";
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

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixos-unstable,
      home-manager,
      nixos-apple-silicon,
      treefmt-nix,
      hax-nur,
      lix-module,
      ninfs,
      srcds-nix,
      sops-nix,
    }:
    let
      r = {
        root = ./.;
        common-nixos = ./common-nixos;
        common-home = ./common-home;
        extras = ./extras;
      };
      mkSpecialArgs = (
        me: system: {
          inherit me inputs r;
          my-inputs = {
            # putting this in cfg-home-manager.nix causes an infinite recursion error
            home-manager-module =
              if (system == "aarch64-darwin" || system == "x86_64-darwin") then
                home-manager.darwinModules.home-manager
              else
                home-manager.nixosModules.home-manager;
            hax-nur = hax-nur.outputs.packages.${system};
            ninfs = ninfs.outputs.packages.${system};
          };
        }
      );
      # these next ones are mainly for treefmt-nix
      systems = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
        "aarch64-darwin"
        "aarch64-linux"
        "armv6l-linux"
        "armv7l-linux"
      ];
      forAllSystems = f: nixos-unstable.lib.genAttrs systems (system: f system);
      treefmtEval = forAllSystems (
        system:
        let
          pkgs = import nixos-unstable { inherit system; };
        in
        treefmt-nix.lib.evalModule pkgs ./treefmt.nix
      );
    in
    {
      darwinConfigurations = {
        # MacBook Pro
        "alphinaud" = nix-darwin.lib.darwinSystem (
          let
            me = "ianburgwin";
            system = "aarch64-darwin";
          in
          rec {
            inherit system;

            specialArgs = mkSpecialArgs me system;

            modules = [ ./nix-darwin-alphinaud/darwin-configuration.nix ];
          }
        ); # alphinaud

        # for testing in macOS virtual machines (basically the same but lacking masapps)
        "MacVM" = nix-darwin.lib.darwinSystem (
          let
            me = "gordonfreeman";
            system = "aarch64-darwin";
          in
          rec {
            inherit system;

            specialArgs = mkSpecialArgs me system;

            modules = [
              ./nix-darwin-alphinaud/darwin-configuration.nix

              (
                { lib, ... }:
                {
                  homebrew.masApps = lib.mkForce { };
                  # assuming i made my vm with "gordonfreeman"
                  networking.hostName = lib.mkForce "Gordons-Virtual-Machine";
                }
              )
            ]; # modules
          }
        ); # MacVM

        # ADDITIONAL SYSTEMS (stuff that is not maintained as much)
        "Ians-MBP" = nix-darwin.lib.darwinSystem (
          let
            me = "ihaveahax";
            system = "x86_64-darwin";
          in
          rec {
            inherit system;

            specialArgs = mkSpecialArgs me system;

            modules = [ ./additional-systems/nix-darwin-imacbook/darwin-configuration.nix ];
          }
        ); # Ians-MBP
      };

      nixosConfigurations = {
        "thancred" = nixos-unstable.lib.nixosSystem (
          let
            me = "ihaveahax";
            system = "x86_64-linux";
          in
          {
            inherit system;

            specialArgs = mkSpecialArgs me system;

            modules = [ ./nixos-thancred/configuration.nix ];
          }
        ); # thancred

        "homeserver" = nixos-unstable.lib.nixosSystem (
          let
            me = "ihaveahax";
            system = "x86_64-linux";
          in
          {
            inherit system;

            specialArgs = mkSpecialArgs me system;

            modules = [ ./nixos-homeserver/configuration.nix ];
          }
        ); # homeserver

        "tataru" = nixos-unstable.lib.nixosSystem (
          let
            me = "ihaveahax";
            system = "x86_64-linux";
          in
          {
            inherit system;

            specialArgs = mkSpecialArgs me system;

            modules = [ ./nixos-tataru/configuration.nix ];
          }
        ); # tataru

        # ADDITIONAL SYSTEMS (stuff that is not maintained as much)

        "asahinix" = nixos-unstable.lib.nixosSystem (
          let
            me = "ihaveahax";
            system = "aarch64-linux";
          in
          {
            inherit system;

            specialArgs = mkSpecialArgs me system;

            modules = [ ./additional-systems/nixos-asahinix/configuration.nix ];
          }
        ); # asahinix

        "imacbooknix" = nixos-unstable.lib.nixosSystem (
          let
            me = "ihaveahax";
            system = "x86_64-linux";
          in
          {
            inherit system;

            specialArgs = mkSpecialArgs me system;

            modules = [ ./additional-systems/nixos-imacbooknix/configuration.nix ];
          }
        ); # imacbooknix

        "liveimage" = nixos-unstable.lib.nixosSystem (
          let
            me = "nixos";
            system = "x86_64-linux";
          in
          {
            inherit system;

            specialArgs = mkSpecialArgs me system;

            modules = [
              ./additional-systems/nixos-liveimage/configuration.nix
              { environment.etc."nix-config".source = self; }
            ];
          }
        ); # liveimage
      }; # nixosConfigurations

      homeConfigurations = {
        # Steam Deck (SteamOS)
        "deck@krile" = home-manager.lib.homeManagerConfiguration (
          let
            system = "x86_64-linux";
            pkgs = import nixos-unstable { inherit system; };
          in
          {
            inherit pkgs;

            extraSpecialArgs = mkSpecialArgs "deck" system;

            modules = [ ./hm-krile/home.nix ];
          }
        );
      }; # homeConfigurations

      devShells.x86_64-linux.default = import ./shell.nix {
        pkgs = import nixos-unstable { system = "x86_64-linux"; };
      };

      packages = {
        x86_64-linux =
          let
            pkgs = import nixos-unstable { system = "x86_64-linux"; };
          in
          rec {
            default = all-systems;
            all-systems = pkgs.callPackage ./extras/deriv-all-systems.nix {
              flakeConfigurations = {
                nixos-thancred = self.nixosConfigurations.thancred.config.system.build.toplevel;
                nixos-tataru = self.nixosConfigurations.tataru.config.system.build.toplevel;
                nixos-homeserver = self.nixosConfigurations.homeserver.config.system.build.toplevel;
                hm-krile = self.homeConfigurations."deck@krile".activationPackage;
              };
              flakeInputs = self.inputs;
            };
            iso = pkgs.callPackage ./extras/deriv-iso.nix { nixosSystem = self.nixosConfigurations.liveimage; };
          };

        aarch64-darwin =
          let
            pkgs = import nixos-unstable { system = "aarch64-darwin"; };
          in
          rec {
            default = all-systems;
            all-systems = pkgs.callPackage ./extras/deriv-all-systems.nix {
              flakeConfigurations = {
                nix-darwin-alphinaud = self.darwinConfigurations.alphinaud.system;
              };
              flakeInputs = self.inputs;
            };
          };
      };

      formatter = forAllSystems (system: treefmtEval.${system}.config.build.wrapper);
      checks = forAllSystems (system: {
        formatting = treefmtEval.${system}.config.build.check self;
      });
    };
}
