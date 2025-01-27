{
  config,
  lib,
  pkgs,
  me,
  my-inputs,
  ...
}:

let
  refresh-nextcloud-files = pkgs.writeShellScriptBin "refresh-nextcloud-files" ''
    if [[ "$(id -u)" -ne 0 ]]; then
      echo "$(basename $0) needs to be run as root"
      sudo bash "$0" "$*"
      exit
    fi

    declare -A paths
    paths[0,0]="${config.services.nextcloud.datadir}/data"
    paths[0,1]="640"
    paths[0,2]="751"
    paths[1,0]="/data/jellyfin-media"
    paths[1,1]="664"
    paths[1,2]="775"

    NC_DATADIR=${config.services.nextcloud.datadir}/data

    for p in {0..1}; do

      path="''${paths[$p,0]}"

      echo "$path"
      echo "Changing ownership"
      chown -R nextcloud:nextcloud "$path"

      echo "Fixing directory modes"
      find "$path" -type d -exec chmod "''${paths[$p,2]}" {} +
      echo "Fixing file modes"
      find "$path" -type f -exec chmod "''${paths[$p,1]}" {} +

    done

    ${config.services.nextcloud.occ}/bin/nextcloud-occ files:scan --all
    ${config.services.nextcloud.occ}/bin/nextcloud-occ preview:pre-generate -vvv
  '';
in
{
  sops.secrets.nextcloud-admin-pass = {
    owner = config.users.users.nextcloud.name;
    group = config.users.users.nextcloud.group;
  };

  # When setting up on a new system, set services.nextcloud.config.adminpassFile
  # https://wiki.nixos.org/wiki/Nextcloud
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
    hostName = "homeserver.tail08e9a.ts.net";
    https = true;
    maxUploadSize = "16G";
    extraApps = {
      # contacts fails to build due to a hash change
      inherit (config.services.nextcloud.package.packages.apps)
        calendar
        notes
        music
        mail
        bookmarks
        previewgenerator
        richdocuments
        ;
      contacts = pkgs.fetchNextcloudApp {
        hash = "sha256-Slk10WZfUQGsYnruBR5APSiuBd3jh3WG1GIqKhTUdfU=";
        url = "https://github.com/nextcloud-releases/contacts/releases/download/v6.1.2/contacts-v6.1.2.tar.gz";
        license = "agpl3Only";
        description = "contacts app";
      };
    };
    phpOptions = {
      "opcache.interned_strings_buffer" = "23";
    };
    phpExtraExtensions = all: [
      (all.smbclient.overrideAttrs (oldAttrs: {
        #version = "1.1.1";
        #sha256 = lib.fakeHash;
        src = pkgs.fetchFromGitHub {
          owner = "eduardok";
          repo = "libsmbclient-php";
          rev = "1.1.1";
          sha256 = "sha256-BK3eNN+rstcRPVdANpTScz/ZdXfGk0nDLoOU7Q1qCi8=";
        };
      }))
    ];
    extraAppsEnable = true;
    configureRedis = true;
    config = {
      adminpassFile = config.sops.secrets.nextcloud-admin-pass.path;
      dbtype = "pgsql";
    };
    settings = {
      preview_ffmpeg_path = "${pkgs.ffmpeg}/bin/ffmpeg";
      enable_previews = true;
      enabledPreviewProviders = [
        "OC\\Preview\\TXT"
        "OC\\Preview\\MarkDown"
        "OC\\Preview\\OpenDocument"
        "OC\\Preview\\PDF"
        "OC\\Preview\\MSOffice2003"
        "OC\\Preview\\MSOfficeDoc"
        "OC\\Preview\\Image"
        "OC\\Preview\\Photoshop"
        "OC\\Preview\\TIFF"
        "OC\\Preview\\SVG"
        "OC\\Preview\\Font"
        "OC\\Preview\\MP3"
        "OC\\Preview\\Movie"
      ];
      trusted_domains = [
        "homeserver" # tailscale
        "192.168.1.10" # local ip address on the spectrum router
        "homeserver.local" # avahi i think???
      ];
      trusted_proxies = [ "127.0.0.1" ];
      maintenance_window_start = 1;
      "localstorage.umask" = "0022";
    };
    database.createLocally = true;
  };

  # i might be able to put this behind a reverse proxy again...
  #services.collabora-online = {
  #  enable = true;
  #  port = 8443;
  #  settings = {
  #    server_name = "homeserver.tail08e9a.ts.net";
  #  };
  #  aliasGroups = [
  #    {
  #      host = "https://homeserver.tail08e9a.ts.net";
  #      aliases = [ "https://localhost" "https://127.0.0.1" ];
  #    }
  #  ];
  #};

  #networking.firewall.allowedTCPPorts = [
  #  8443
  #];

  systemd = {
    timers."refresh-nextcloud-files-auto" = {
      wantedBy = [ "timers.target" ];
      after = [ "nextcloud-setup.service" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        Unit = "refresh-nextcloud-files-auto.service";
      };
    };
    services."refresh-nextcloud-files-auto" = {
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${refresh-nextcloud-files}/bin/refresh-nextcloud-files";
      };
    };
  };

  environment.systemPackages = [
    refresh-nextcloud-files
  ];
}
