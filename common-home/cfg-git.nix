{ config, pkgs, ... }:

let
  allowedSignersPath = "${config.home.homeDirectory}/.ssh/allowed_signers";
in
{
  programs.git = {
    enable = true;
    userEmail = "ian@ianburgwin.net";
    userName = "ihaveahax";
    ignores = [
      # Python
      "__pycache__/"
      "__pypackages__/"
      ".env"
      ".venv"
      "env/"
      "venv/"
      "venv*/"
      "ENV/"
      "env.bak/"
      "venv.bak/"
      # macOS
      "._*"
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      ".DocumentRevisions-V100"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      ".com.apple.timemachine.donotpresent"
      # Linux
      ".Trash-*"
      # Windows
      "[Dd]esktop.ini"
      "Thumbs.db"
      # IntelliJ IDEA
      ".idea/**/workspace.xml"
      ".idea/**/tasks.xml"
      ".idea/**/usage.statistics.xml"
      ".idea/**/dictionaries"
      ".idea/**/shelf"
      ".idea/**/contentModel.xml"
      ".idea/**/dataSources/"
      ".idea/**/dataSources.ids"
      ".idea/**/dataSources.local.xml"
      ".idea/**/sqlDataSources.xml"
      ".idea/**/dynamic.xml"
      ".idea/**/uiDesigner.xml"
      ".idea/**/dbnavigator.xml"
      ".idea/**/gradle.xml"
      ".idea/**/libraries"
      ".idea/**/mongoSettings.xml"
      ".idea_modules/"
      ".idea/replstate.xml"
      ".idea/httpRequests"
      ".idea/caches/build_file_checksums.ser"
      # Syncthing
      ".stfolder"
      ".stversions"
    ];
    extraConfig = {
      # taken from my mac gitconfig
      push = { default = "current"; };
      pull = { rebase = false; };
      init = { defaultBranch = "main"; };
      gpg = {
        format = "ssh";
        ssh.allowedSignersFile = allowedSignersPath;
      };
    };
    signing.key = "${config.home.homeDirectory}/.ssh/id_rsa.pub";
  };

  home.file.${allowedSignersPath}.source = ./allowed_signers;
}
