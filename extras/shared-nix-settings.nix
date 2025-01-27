{
  config,
  lib,
  pkgs,
  ...
}:

# shared across NixOS, nix-darwin, and Home Manager
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.package = pkgs.lix;

  nix.registry = {
    jovian = {
      from = {
        id = "jovian";
        type = "indirect";
      };
      to = {
        owner = "Jovian-Experiments";
        repo = "Jovian-NixOS";
        type = "github";
      };
    };
    nixos-apple-silicon = {
      from = {
        id = "nixos-apple-silicon";
        type = "indirect";
      };
      to = {
        owner = "tpwrules";
        repo = "nixos-apple-silicon";
        type = "github";
      };
    };
    hax-nur = {
      from = {
        id = "hax-nur";
        type = "indirect";
      };
      to = {
        owner = "ihaveamac";
        repo = "nur-packages";
        type = "github";
      };
    };
    ninfs = {
      from = {
        id = "ninfs";
        type = "indirect";
      };
      to = {
        owner = "ihaveamac";
        repo = "ninfs";
        type = "github";
      };
    };
    pyctr = {
      from = {
        id = "pyctr";
        type = "indirect";
      };
      to = {
        owner = "ihaveamac";
        repo = "pyctr";
        type = "github";
      };
    };
  };
  nix.settings = {
    # this was originally set by nix-darwin
    bash-prompt-prefix = "(nix:$name)\\040";
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-nix-path = [
      "nixpkgs=flake:nixpkgs"
      "nur=flake:nur"
      "hax-nur=flake:hax-nur"
    ];
    # mkForce is used here because on a home-manager setup, not including cache.nixos.org seems to cause nix to ignore it
    # but on NixOS (and maybe nix-darwin), it is already included, so adding it would normally include it twice
    # so i use mkForce here to make it only list the ones i want
    substituters = lib.mkForce [
      "https://cache.nixos.org"
      "https://ihaveahax.cachix.org"
      "https://attic.ihaveahax.net/ihaveahax"
    ];
    trusted-public-keys = lib.mkForce [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "ihaveahax.cachix.org-1:587ONPwRnx0AQu27y7rD1f7jTj2isGRAVDVddKEAv7I="
      "ihaveahax:oiYXxjqHZYe4OzvX6CGFfUIK9HEZBWPS0y7DpcZ5Cok="
    ];
    # this will be overridden in home-manager
    netrc-file = "/etc/nix/netrc";
    use-xdg-base-directories = true;
  };
}
