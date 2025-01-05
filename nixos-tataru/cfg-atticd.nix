{ config, lib, pkgs, ... }:

let
  localPort = 8909;
  keyDir = "/var/keys/atticd";
  envFile = "atticd.env";
in
{
  services.nginx = {
    clientMaxBodySize = "4g";
    virtualHosts."attic.ihaveahax.net" = {
      useACMEHost = "ihaveahax.net";
      forceSSL = true;
      locations."/" = {
        recommendedProxySettings = true;
        #proxyPass = "http://${config.containers.atticd.localAddress}:${toString localPort}";
        proxyPass = "http://atticd:${toString localPort}";
      };
    };
  };

  containers.atticd = {
    autoStart = true;
    ephemeral = true;
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.12";
    bindMounts = {
      atticdEnv = {
        hostPath = "/var/keys/atticd";
        mountPoint = "/var/keys/atticd";
        isReadOnly = true;
      };
      postgresql = {
        hostPath = "/var/lib/postgresql-atticd";
        mountPoint = "/var/lib/postgresql";
        isReadOnly = false;
      };
    };
    config = { config, pkgs, lib, ... }: {
      system.switch.enable = false;
      services.atticd = {
        enable = true;
        environmentFile = "/var/keys/atticd/atticd.env";
        settings = {
          listen = "[::]:${toString localPort}";
          database.url = "postgresql:///atticd?host=/run/postgresql";
          require-proof-of-possession = false;
          storage = {
            type = "s3";
            region = "us-east-1";
            bucket = "ihaveahax-attic";
            endpoint = "https://nyc3.digitaloceanspaces.com";
          };
          # Data chunking
          #
          # Warning: If you change any of the values here, it will be
          # difficult to reuse existing chunks for newly-uploaded NARs
          # since the cutpoints will be different. As a result, the
          # deduplication ratio will suffer for a while after the change.
          chunking = {
            # The minimum NAR size to trigger chunking
            #
            # If 0, chunking is disabled entirely for newly-uploaded NARs.
            # If 1, all NARs are chunked.
            nar-size-threshold = 64 * 1024; # 64 KiB

            # The preferred minimum size of a chunk, in bytes
            min-size = 16 * 1024; # 16 KiB

            # The preferred average size of a chunk, in bytes
            avg-size = 64 * 1024; # 64 KiB

            # The preferred maximum size of a chunk, in bytes
            max-size = 256 * 1024; # 256 KiB
          };
          garbage-collection = {
            default-retention-period = "2 months";
          };
        };
      };

      services.postgresql = {
        enable = true;
        package = pkgs.postgresql_17;
        ensureDatabases = [ "atticd" ];
        ensureUsers = [
          {
            name = "atticd";
            ensureDBOwnership = true;
          }
        ];
      };

      users.users.atticd = {
        isSystemUser = true;
        #home = "/var/lib/atticd";
        home = "/var/empty";
        group = "atticd";
        #createHome = true;
      };
      users.groups.atticd.members = [ "atticd" ];

      networking = {
        firewall.allowedTCPPorts = [ localPort ];
        #useHostResolvConf = false;
        #resolvconf.useLocalResolver = false;
      };

      system.stateVersion = "24.11";
    };
  };
}
