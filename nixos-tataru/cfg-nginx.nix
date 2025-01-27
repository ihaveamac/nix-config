{
  config,
  lib,
  pkgs,
  ...
}:

let
in
{
  services.nginx = {
    enable = true;
    virtualHosts = {
      "ihaveahax.net" = {
        useACMEHost = "ihaveahax.net";
        forceSSL = true;
        root = "/var/www/ihaveahax.net";
        locations = {
          "/.well-known" = {
            #root = wwwRoot;
            extraConfig = "default_type text/plain;";
          };
        };
      };
      "ianburgwin.net" = {
        useACMEHost = "ianburgwin.net";
        forceSSL = true;
        root = "/var/www/ianburgwin.net";
        locations = {
          "/" = {
            tryFiles = "$uri $uri/ =404";
          };
          "/hax" = {
            extraConfig = "autoindex on;";
          };
          "/hax/smashbroshax-helper.zip" = {
            extraConfig = "rewrite ^.* /hax/smashbroshax-removed.php permanent;";
          };
          "~ ^/(index|test|hax/index|hax/smashbroshax-removed)\\.php$" = {
            extraConfig = ''
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              fastcgi_pass  unix:${config.services.phpfpm.pools.generic.socket};
            '';
          };
          "~ /\\.ht" = {
            extraConfig = "deny all;";
          };
          # older sites
          "/ez3ds".extraConfig = "return 302 https://ihaveahax.net/wiki/ez3ds;";
          "/old/ez3ds.html".extraConfig = "return 302 https://ihaveahax.net/wiki/ez3ds;";
          "~* ^/3dsflow-downloader-(.*)\\.zip$".extraConfig =
            "return 302 https://ihaveahax.net/view/3DSFlow;";
          "= /3dsflow".extraConfig = "return 302 https://ihaveahax.net/view/3DSFlow;";
          "= /3dsflow/".extraConfig = "return 302 https://ihaveahax.net/view/3DSFlow;";
          "/ctr/dump".extraConfig = "return 302 https://wiki.hacks.guide/wiki/3DS:Dump_system_files;";
        };
      };
      "luigoalma.ianburgwin.net" = {
        useACMEHost = "ianburgwin.net";
        forceSSL = true;
        root = "/var/www/luigoalma.ianburgwin.net";
        locations = {
          "/" = {
            index = "index.php index.html index.htm index.nginx-debian.html";
            tryFiles = "$uri $uri/ =404";
          };
          "~ \\.php$".extraConfig = ''
            fastcgi_pass  unix:${config.services.phpfpm.pools.generic.socket};
            fastcgi_index index.php;
          '';
        };
      };
      "tataru.ihaveahax.net" = {
        useACMEHost = "ihaveahax.net";
        forceSSL = true;
        root = "/var/www/tataru.ihaveahax.net";
        locations = {
          "/" = {
            index = "index.html";
            tryFiles = "$uri $uri/ =404";
          };
        };
      };
      "switchgui.de" = {
        useACMEHost = "switchgui.de";
        forceSSL = true;
        root = "/var/www/switchgui.de";
        locations = {
          #"/web-payload" = {};
          "/web-payload".extraConfig = "return 302 https://fusee.nintendohomebrew.com/;";
          "/switch-guide".extraConfig = "return 302 https://switch.hacks.guide$request_uri;";
          "/".extraConfig = "return 302 https://switch.hacks.guide/;";
        };
      };
      "*.ihaveahax.net" = {
        useACMEHost = "ihaveahax.net";
        forceSSL = true;
        root = "/var/www/default";
        locations = {
          "/" = { };
        };
      };
      "*.ianburgwin.net" = {
        useACMEHost = "ianburgwin.net";
        forceSSL = true;
        root = "/var/www/default";
        locations = {
          "/" = { };
        };
      };
    };
  };

  services.phpfpm.pools.generic = {
    # maybe this should be a different user?
    user = "nginx";
    phpPackage = pkgs.php83;
    settings = {
      "listen.owner" = config.services.nginx.user;
      "pm" = "dynamic";
      "pm.max_children" = 32;
      "pm.max_requests" = 500;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 2;
      "pm.max_spare_servers" = 5;
      "php_admin_value[error_log]" = "stderr";
      "php_admin_flag[log_errors]" = true;
      "catch_workers_output" = true;
    };
  };

  sops.secrets = {
    "do-auth-token" = {
      owner = config.users.users.acme.name;
      group = config.users.users.acme.group;
    };
    "do-auth-token-nintendohomebrew" = {
      owner = config.users.users.acme.name;
      group = config.users.users.acme.group;
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "ian@ianburgwin.net";
      dnsProvider = "digitalocean";
      dnsPropagationCheck = true;
      credentialFiles = {
        "DO_AUTH_TOKEN_FILE" = config.sops.secrets.do-auth-token.path;
      };
    };
    certs = {
      "ihaveahax.net" = {
        domain = "ihaveahax.net";
        extraDomainNames = [ "*.ihaveahax.net" ];
      };
      "ianburgwin.net" = {
        domain = "ianburgwin.net";
        extraDomainNames = [ "*.ianburgwin.net" ];
      };
      "switchgui.de" = {
        domain = "switchgui.de";
        extraDomainNames = [ "*.switchgui.de" ];
        credentialFiles = {
          "DO_AUTH_TOKEN_FILE" = config.sops.secrets.do-auth-token-nintendohomebrew.path;
        };
      };
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];
}
