{
  pkgs ? import <nixpkgs> { },
}:

let
  inherit (pkgs) fetchFromGitHub;
  # Get Wikimedia Extension
  getWMExtension = import ../func-get-wm-extension.nix { inherit pkgs; };
in
{
  CodeMirror = getWMExtension {
    name = "CodeMirror";
    rev = "3def77c029ea8d5c74856710f5e231fd2d9185ae";
    hash = "sha256-TFA0CtLiLr6abjmVeu8m89xEI7jMLPJy7AO1kDS3AOY=";
  };
  Loops = getWMExtension {
    name = "Loops";
    rev = "dee5dd131110a73ebcb3c09cad9eec0e130f9315";
    hash = "sha256-oNuHQhr9p5rs+gWufooNE6UCf7TSJiY13R8DkLEf7S0=";
  };
  MagicNoCache = getWMExtension {
    name = "MagicNoCache";
    rev = "7315339c97c0eb7d528a8f6b14d055812a85fdb2";
    hash = "sha256-5GKLmffFa1uSq+sLNusgzRzc9CplBW6z4gk3+MUjBxY=";
  };
  DynamicSidebar = getWMExtension {
    name = "DynamicSidebar";
    rev = "17edfd771950ffe035176daa6d0058bd942e8497";
    hash = "sha256-VOYCcgjYGsAJ1g2QCP06EsHX6qmM9hUTtOF95Pkpm7c=";
  };
  MobileFrontend = getWMExtension {
    name = "MobileFrontend";
    rev = "aae56d488072b725c8df9126567f1c068bbc4e59";
    hash = "sha256-ZKsDFzC10bwvVm7IQfY+uEzXInPq5WR49C/jVm0jVtk=";
  };
  SecureLinkFixer = getWMExtension {
    name = "SecureLinkFixer";
    rev = "2435a55c6bee4c23b8face5d53b6cb9c2d2680d2";
    hash = "sha256-pur43ljY+gTojkfIdPVha/D5JvhrhGz35mGdOcANyTE=";
  };
}
