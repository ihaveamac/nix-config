# TODO: move branch stuff to separate file?
{
  pkgs ? import <nixpkgs> { },
  defaultBranch ? "REL1_39",
}:

let
  inherit (pkgs) fetchFromGitHub;
  # Get Wikimedia Extension
  getWMExtension =
    {
      name,
      rev,
      hash,
      branch ? null,
    }:
    let
      ext = fetchFromGitHub {
        inherit rev hash;
        owner = "wikimedia";
        repo = "mediawiki-extensions-${name}";
        passthru = {
          branch = if branch == null then defaultBranch else branch;
          # this is kind of a hack
          src = ext;
          # this is also kind of a hack (prevent nix-update from updating the useless version
          version = "0" + "0";
        };
      };
    in
    ext;
in
{
  CodeMirror = getWMExtension {
    name = "CodeMirror";
    rev = "6b52309fa9a1b3641f7ec0c51c6316e6a3313584";
    hash = "sha256-+D5NYR51Vdkszh5/Lfj7+6bX2OsD5VeL6zTYWLW4pe0=";
  };
  Loops = getWMExtension {
    name = "Loops";
    rev = "83cd81d53ad49d1d46050203d74836f6d3534fea";
    hash = "sha256-mJL5SRjGKrNz9SKeMEByshDf6N4rcb+WJAFRPF/UqUc=";
  };
  MagicNoCache = getWMExtension {
    name = "MagicNoCache";
    rev = "6cd009edb302f33fb04f9f011ad3495dabe65285";
    hash = "sha256-Qar2K0T9zxIzmaiPmxJWy8GeL8VNfOYqMZTlsnlRmks=";
  };
  DynamicSidebar = getWMExtension {
    name = "DynamicSidebar";
    rev = "cb47238cb06fec2a554be36b519cc413af3b65cd";
    hash = "sha256-vRlHw9jlvQHY58MyyAut2xA1Yeslto4DlD3u5fsxj8E=";
  };
  MobileFrontend = getWMExtension {
    name = "MobileFrontend";
    rev = "7d52772552f59542f7fc37485d322855faafd01f";
    hash = "sha256-R82BXNq9TcmlaVEqFqecweEpXPRVHPumNmpWz0WMeD8=";
  };
  SecureLinkFixer = getWMExtension {
    name = "SecureLinkFixer";
    rev = "b67e07ca51cd7d9c7d7d2adb5a8bba74e1550d9a";
    hash = "sha256-yMIxgqRFBe1NIuTWR01dZOoNcwDBk4H9sGR3+XCwdPo=";
  };
}
