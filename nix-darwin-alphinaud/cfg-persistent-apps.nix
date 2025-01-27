{
  config,
  lib,
  pkgs,
  me,
  ...
}:

{
  system.defaults.dock.persistent-apps = [
    "/System/Cryptexes/App/System/Applications/Safari.app"
    "/System/Applications/Mail.app"
    "/System/Applications/Calendar.app"
    "/Applications/Things3.app"
    "/Applications/Discord.app"
    "/Applications/Telegram.app"
    "/Applications/Textual.app"
    "/Applications/Reeder.app"
    "/Applications/EagleFiler.app"
    "/Applications/XIV on Mac.app"
    "/Applications/Strongbox.app"
    "/Applications/Nix Apps/Hex Fiend.app"
    "/Applications/CotEditor.app"
    "/Applications/VimR.app"
    "/Applications/Nova.app"
    "/Users/${me}/Applications/PyCharm Professional Edition.app"
    "/Applications/iA Writer.app"
    "/Applications/Pixelmator Pro.app"
    "/Applications/Transmit.app"
    "/Applications/iTerm.app"
  ];
}
