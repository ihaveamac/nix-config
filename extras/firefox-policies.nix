let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in
{
  DisableTelemetry = true;
  DisableFirefoxStudies = true;
  DisablePocket = true;
  EnableTrackingProtection = {
    Value = true;
    Cryptomining = true;
    Fingerprinting = true;
    EmailTracking = true;
  };
  DisplayBookmarksToolbar = "newtab";
  DontCheckDefaultBrowser = true;
  SearchBar = "unified";

  ExtensionSettings = {
    "uBlock0@raymondhill.net" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      installation_mode = "force_installed";
    };
    "plasma-browser-integration@kde.org" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/plasma-integration/latest.xpi";
      installation_mode = "force_installed";
    };
    "keepassxc-browser@keepassxc.org" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi";
      installation_mode = "force_installed";
    };
    "{bf9e77ee-c405-4dd7-9bed-2f55e448d19a}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/jetbrains-toolbox/latest.xpi";
      installation_mode = "force_installed";
    };
    "nekocaption@gmail.com" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/nekocap/latest.xpi";
      installation_mode = "force_installed";
    };
  };

  Preferences = {
    "extensions.pocket.enabled" = lock-false;
    # https://gladtech.social/@cuchaz/112775302929069283
    # i think i set this right?
    "dom.private-attribution.submission.enabled" = lock-false;
    "browser.shopping.experience2023.active" = lock-false;
    "browser.shopping.experience2023.survey.enabled" = lock-false;
    "browser.newtabpage.activity-stream.showSponsored" = lock-false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
    "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
    "browser.urlbar.sponsoredTopSites" = lock-false;
    "browser.ml.enable" = lock-false;
    "browser.ml.linkPreview.enabled" = lock-false;
    "browser.ml.chat.enabled" = lock-false;
    "browser.topsites.contile.enabled" = lock-false;
  };
}
