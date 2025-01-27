{
  config,
  lib,
  pkgs,
  ...
}:

let
  wrapComposerPackage = pkgs.callPackage ./wrap-composer-package.nix { };
  mkExtensionWithComposer = file: pkgs.callPackage file { inherit wrapComposerPackage; };
  php = pkgs.php83;
in
{
  imports = [
    ./module-mediawiki.nix
    ./cfg-mediawiki-extensions.nix
  ];
  hax.services.mediawiki = {
    enable = true;
    webserver = "nginx";
    package = pkgs.hax.mediawiki_1_39;
    passwordFile = "/run/keys/mediawiki-password";
    phpPackage = php.withExtensions (
      { enabled, all }: enabled ++ [ (pkgs.callPackage ./deriv-luasandbox.nix { inherit php; }) ]
    );
    nginx.hostName = "ihaveahax.net";
    extensions = {
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

      #QRLite = mkExtensionWithComposer ./deriv-qrlite.nix;
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

  services.nginx.virtualHosts = {
    ${config.hax.services.mediawiki.nginx.hostName} = {
      useACMEHost = "ihaveahax.net";
      serverAliases = [ "www.ihaveahax.net" ];
      forceSSL = true;
      locations = {
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
