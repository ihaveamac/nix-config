{
  config,
  lib,
  pkgs,
  ...
}:

let
  hostname = "ihaveahax.net";
  simpleExtensions = import ./simple-extensions { inherit pkgs; };
  composerExtensions = import ./composer-extensions { inherit pkgs; };
  php = pkgs.php83;
  mediawikiPackage = pkgs.hax.mediawiki_1_43;
in
{
  sops.secrets."mediawiki-password" = { };

  containers.mediawiki = {
    autoStart = true;
    ephemeral = true;
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.13";
    bindMounts = {
      mediawikiPassword = {
        hostPath = "/run/secrets/mediawiki-password";
        mountPoint = "/run/mediawiki-password";
        isReadOnly = true;
      };
      mediawikiData = {
        hostPath = "/var/lib/mediawiki";
        mountPoint = "/var/lib/mediawiki";
        isReadOnly = false;
      };
      mysql = {
        hostPath = "/var/lib/mysql-mediawiki";
        mountPoint = "/var/lib/mysql";
        isReadOnly = false;
      };
    };
    config = { config, lib, pkgs, ... }: {
      imports = [
        ./module-mediawiki.nix
      ];
      system.switch.enable = false;
      hax.services.mediawiki = {
        enable = true;
        webserver = "nginx";
        package = mediawikiPackage;
        passwordFile = "/run/mediawiki-password";
        phpPackage = php.withExtensions (
          { enabled, all }: enabled ++ [ (pkgs.callPackage ./deriv-luasandbox.nix { inherit php; }) ]
        );
        nginx.hostName = hostname;
        extensions = {
          inherit (simpleExtensions)
            CodeMirror
            Loops
            MagicNoCache
            DynamicSidebar
            MobileFrontend
            SecureLinkFixer
            ;
          inherit (composerExtensions) QRLite TemplateStyles Variables;

          Interwiki = null;
          Nuke = null;
          ReplaceText = null;
          CodeEditor = null;
          WikiEditor = null;
          CategoryTree = null;
          Cite = null;
          InputBox = null;
          ParserFunctions = null;
          Scribunto = null;
          SyntaxHighlight_GeSHi = null;
          PageImages = null;

          # simple extensions not included in the base package are in cfg-mediawiki-extensions.nix
          # others that require composer should go here and need manual updating from time to time
          # (until i make some better tooling...)
        };
        extraConfig = ''
          # hax.services.mediawiki.extraConfig
          $wgUseInstantCommons = true;
          $wgEnableEmail = false;

          $wgGroupPermissions['sysop']['interwiki'] = true;
          $wgGroupPermissions['*']['createaccount'] = false;
          $wgGroupPermissions['*']['edit'] = false;
          $wgGroupPermissions['user']['upload_by_url'] = false;

          $logoPrefix = 'https://files-ihaveahax-sfo3.sfo3.digitaloceanspaces.com/shlimaz-symmetric-headshot';

          $wgLogos = [
            '1x'   => "$logoPrefix/Logo-135.png",
            '1.5x' => "$logoPrefix/Logo-202.png",
            '2x'   => "$logoPrefix/Logo-270.png",
            'icon' => "$logoPrefix/Logo-50.png",
          ];

          $wgDefaultSkin = "monobook";
          $wgMaxImageArea = 2e7;
          $wgSitename = "ihaveahax's Site";
          $wgMetaNamespace = "Project";
          $wgRestrictDisplayTitle = false;
          $wgNamespacesWithSubpages[NS_MAIN] = true;
          $wgCapitalLinkOverrides[NS_MAIN] = false;
          $wgCapitalLinkOverrides[NS_CATEGORY] = false;
          $wgCapitalLinkOverrides[NS_FILE] = false;
          $wgAllowCopyUploads = true;
          $wgCopyUploadsFromSpecialUpload = true;
          $wgNoFollowLinks = false;
          $wgStrictFileExtensions = false;
          $wgCheckFileExtensions = false;
          $wgVerifyMimeType = false;
          $wgRawHtml = true;
          $wgUseNPPatrol = false;
          $wgUseRCPatrol = false;
          $wgFeed = false;
          $wgMaxRedirects = 42;
          $wgFixDoubleRedirects = true;
          $wgUniversalEditButton = false;
          $wgWatchlistExpiry = false;
          $wgDisableUploadScriptChecks = true;
          $wgImportSources = [ "wikipedia", "mediawikiwiki", "commons"];
          $wgMFDefaultSkinClass = 'SkinMinerva';
          $wgDefaultUserOptions['usecodemirror'] = 1;
          $wgAllowUserCss = true;
          $wgPFEnableStringFunctions = true;
          $wgDynamicSidebarUseUserpages = true;
          $wgDynamicSidebarUseGroups = true;
          $wgDynamicSidebarUseCategories = true;
          $wgPygmentizePath = "${pkgs.python3Packages.pygments}/bin/pygmentize";
        '';
      };

      networking.firewall.allowedTCPPorts = [ 80 ];

      system.stateVersion = "24.05";
    };
  };

  services.nginx.virtualHosts = {
    ${hostname} = {
      serverAliases = [ "www.ihaveahax.net" ];
      locations = {
        "= /".extraConfig = ''
          return 302 /wiki/Main_Page;
        '';
        "= /w".extraConfig = ''
          return 302 /wiki/Main_Page;
        '';
        "/wiki/" = {
          recommendedProxySettings = true;
          proxyPass = "http://mediawiki.containers";
        };
        "/w/" = {
          recommendedProxySettings = true;
          proxyPass = "http://mediawiki.containers";
        };
        "~ ^/view/(.*)$".extraConfig = ''
          rewrite ^/view/(.*)$ /wiki/$1 redirect;
        '';
        "= /view".extraConfig = ''
          return 302 /wiki/Main_Page;
        '';
      };
    };
  };
}
