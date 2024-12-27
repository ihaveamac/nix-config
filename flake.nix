{
  description = "ihaveahax's NixOS, nix-darwin and Home Manager stuff";

  nixConfig = {
    extra-substituters = [
      "https://ihaveahax.cachix.org"
      "https://cache.lix.systems"
      "https://attic.ihaveahax.net/ihaveahax"
    ];
    extra-trusted-public-keys = [
      "ihaveahax.cachix.org-1:587ONPwRnx0AQu27y7rD1f7jTj2isGRAVDVddKEAv7I="
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      "ihaveahax:oiYXxjqHZYe4OzvX6CGFfUIK9HEZBWPS0y7DpcZ5Cok="
    ];
  };

  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # this passes more tests for NixOS that nixpkgs does not need to
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

  outputs = inputs@{ self, nix-darwin, nixos-unstable, home-manager, nixos-apple-silicon, hax-nur, lix-module, ninfs, srcds-nix, ... }: let
    mkSpecialArgs = (me: system: {
      inherit me inputs;
      my-inputs = {
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

        modules = [
          ./nix-darwin-alphinaud/darwin-configuration.nix
          ./nix-darwin-alphinaud/cfg-masapps.nix
          ./common-nixos/cfg-nix-settings.nix
          ./extras/shared-nix-settings.nix

          hax-nur.nixosModules.overlay
          lix-module.nixosModules.default

          home-manager.darwinModules.home-manager
          ./common-nixos/cfg-home-manager.nix

          {
            home-manager.users.${me}.imports = [
              ./nix-darwin-alphinaud/home.nix
              ./common-home/desktop.nix
              ./common-home/core.nix
            ];
          }
        ]; # modules
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
          ./common-nixos/cfg-nix-settings.nix
          ./common-nixos/cfg-home-manager.nix
          ./extras/shared-nix-settings.nix

          hax-nur.nixosModules.overlay
          lix-module.nixosModules.default

          home-manager.darwinModules.home-manager
          ./common-nixos/cfg-home-manager.nix

          {
            home-manager.users.${me}.imports = [
              ./nix-darwin-alphinaud/home.nix
              ./common-home/desktop.nix
              ./common-home/core.nix
            ];
          }

          ({ lib, ... }: {
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

        modules = [
          ./additional-systems/nix-darwin-imacbook/darwin-configuration.nix
          hax-nur.nixosModules.overlay
          lix-module.nixosModules.default
          home-manager.darwinModules.home-manager
        ];
      }); # Ians-MBP
    };

    nixosConfigurations = {
      "thancred" = nixos-unstable.lib.nixosSystem (let
        me = "ihaveahax";
        system = "x86_64-linux";
      in {
        inherit system;

        specialArgs = mkSpecialArgs me system;

        modules = [
          ./nixos-thancred/configuration.nix
          ./nixos-thancred/hardware-configuration.nix
          ./common-nixos/cfg-ssh.nix
          ./common-nixos/cfg-nix-settings.nix
          ./extras/shared-nix-settings.nix

          hax-nur.nixosModules.overlay

          lix-module.nixosModules.default

          home-manager.nixosModules.home-manager
          ./common-nixos/cfg-home-manager.nix

          {
            home-manager.users.${me}.imports = [
              ./nixos-thancred/home.nix
              ./common-home/linux.nix
              ./common-home/desktop.nix
              ./common-home/core.nix
              hax-nur.hmModules.lnshot
            ];
          }
        ]; # modules
      }); # thancred

      "homeserver" = nixos-unstable.lib.nixosSystem (let
        me = "ihaveahax";
        system = "x86_64-linux";
      in {
        inherit system;

        specialArgs = mkSpecialArgs me system;

        modules = [
          ./nixos-homeserver/configuration.nix
          ./nixos-homeserver/hardware-configuration.nix
          ./common-nixos/cfg-ssh.nix
          ./common-nixos/cfg-nix-settings.nix
          ./extras/shared-nix-settings.nix

          srcds-nix.nixosModules.default
          {
            services.srcds.enable = true;
            services.srcds.openFirewall = true;
            services.srcds.games = {
              tf2 = {
                appId = 232250;
                gamePort = 27015;
                startingMap = "pl_upward";
                rcon = {
                  enable = true;
                  password = "ihaveahax";
                };
                config = {
                  hostname = "NixOS srcds-nix test";
                  sv_password = "ihaveahax";
                };
                extraConfig = ''
                  echo extraConfig executed
                '';
              };
            };
          }

          lix-module.nixosModules.default
          home-manager.nixosModules.home-manager
          ./common-nixos/cfg-home-manager.nix

          {
            home-manager.users.${me}.imports = [
              ./nixos-homeserver/home.nix
              ./common-home/linux.nix
              ./common-home/core.nix
            ];
          }
        ]; # modules
      }); # homeserver

      "tataru" = nixos-unstable.lib.nixosSystem (let
        me = "ihaveahax";
        system = "x86_64-linux";
      in {
        inherit system;

        specialArgs = mkSpecialArgs me system;

        modules = [
          ./nixos-tataru/configuration.nix
          ./nixos-tataru/hardware-configuration.nix
          ./nixos-tataru/networking.nix
          ./common-nixos/cfg-ssh.nix
          ./common-nixos/cfg-nix-settings.nix
          ./extras/shared-nix-settings.nix

          hax-nur.nixosModules.overlay
          lix-module.nixosModules.default
          home-manager.nixosModules.home-manager
          ./common-nixos/cfg-home-manager.nix

          {
            home-manager.users.${me}.imports = [
              ./nixos-tataru/home.nix
              ./common-home/linux.nix
              ./common-home/core.nix
            ];
          }
        ]; # modules
      }); # tataru

      # ADDITIONAL SYSTEMS (stuff that is not maintained as much)

      "asahinix" = nixos-unstable.lib.nixosSystem (let
        me = "ihaveahax";
        system = "aarch64-linux";
      in {
        inherit system;

        specialArgs = mkSpecialArgs me system;

        modules = [
          ./additional-systems/nixos-asahinix/configuration.nix
          ./additional-systems/nixos-asahinix/hardware-configuration.nix
          ./common-nixos/cfg-ssh.nix
          ./common-nixos/cfg-nix-settings.nix
          ./extras/shared-nix-settings.nix

          lix-module.nixosModules.default
          home-manager.nixosModules.home-manager
          ./common-nixos/cfg-home-manager.nix

          {
            home-manager.users.${me}.imports = [
              ./additional-systems/nixos-asahinix/home.nix
              ./common-home/linux.nix
              ./common-home/desktop.nix
              ./common-home/core.nix
            ];
          }

          nixos-apple-silicon.nixosModules.apple-silicon-support
          {
            hardware.asahi = {
              enable = true;
              useExperimentalGPUDriver = true;
              setupAsahiSound = true;
            };

            #boot.kernelParams = [ "apple_dcp.show_notch=1" ];
          }
        ]; # modules
      }); # asahinix

      "imacbooknix" = nixos-unstable.lib.nixosSystem (let
        me = "ihaveahax";
        system = "x86_64-linux";
      in {
        inherit system;

        specialArgs = mkSpecialArgs me system;

        modules = [
          ./additional-systems/nixos-imacbooknix/configuration.nix

          lix-module.nixosModules.default

          home-manager.nixosModules.home-manager
          ./common-nixos/cfg-home-manager.nix

          {
            home-manager.users.${me}.imports = [
              ./additional-systems/nixos-imacbooknix/home.nix
              ./common-home/linux.nix
              ./common-home/desktop.nix
              ./common-home/core.nix
            ];
          }
        ];
      }); # imacbooknix

      "liveimage" = nixos-unstable.lib.nixosSystem (let
        me = "nixos";
        system = "x86_64-linux";
      in {
        inherit system;

        specialArgs = mkSpecialArgs me system;

        modules = [
          "${nixos-unstable}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix"
          ./additional-systems/nixos-liveimage/configuration.nix
          ./extras/shared-nix-settings.nix

          lix-module.nixosModules.default
          home-manager.nixosModules.home-manager
          ./common-nixos/cfg-home-manager.nix

          {
            home-manager.users.${me}.imports = [
              ./additional-systems/nixos-liveimage/home.nix
              ./common-home/cfg-neovim.nix
              ./common-home/linux.nix
              ./common-home/core.nix
            ];
          }

          {
            environment.etc."nix-config".source = self;
          }
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
        modules = [
          ./hm-krile/home.nix
          ./common-home/linux.nix
          ./common-home/desktop.nix
          ./common-home/core.nix
          ./common-home/non-nixos.nix
          ./extras/shared-nix-settings.nix
          hax-nur.hmModules.lnshot
          lix-module.nixosModules.default
        ];
        extraSpecialArgs = mkSpecialArgs "deck" system;
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
        dontBuild = true;
        dontFixup = true;

        installPhase = ''
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
        default = self.packages.x86_64-linux.all-systems;
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
          toplevel = system.config.system.build.toplevel;
          isobase = system.config.system.build.isoImage;
        in pkgs.stdenvNoCC.mkDerivation {
          name = isobase.name + "-static-name";
          preferLocalBuild = true;

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
            ${pkgs.rsync}/bin/rsync -avzLI --progress $isoname macbook-pro:nixos.iso
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
        default = self.packages.aarch64-darwin.all-systems;
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
