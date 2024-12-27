{ config, lib, pkgs, ... }:

# https://wiki.nixos.org/wiki/Distributed_build
{
  # this is so i can set a different hostname while on my home PC (thancred)
  # so it goes purely over LAN and not using the tailscale hostname/IP
  options.hax.homeserverHostName = lib.options.mkOption {
    default = "homeserver";
    type = lib.types.str;
  };

  config.nix = {
    buildMachines = [ {
      hostName = config.hax.homeserverHostName;
      sshUser = "ihaveahax";
      systems = [ "x86_64-linux" "i686-linux" ];
      protocol = "ssh-ng";
      maxJobs = 4;
      #speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
    } ];

    distributedBuilds = true;

    # optional, useful when the builder has a faster internet connection than yours
    # wait, can this be in nix.settings?
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };
}
