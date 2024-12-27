{ config, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    controlMaster = "auto";
    controlPersist = "30m";
    matchBlocks = {
      newnh-root = {
        user = "root";
        hostname = "137.184.230.97";
        port = 26734;
      };
      wiki = {
        user = "ianburgwin";
        hostname = "wiki.hacks.guide";
        port = 26734;
      };
      wiki-root = {
        user = "root";
        hostname = "wiki.hacks.guide";
        port = 26734;
      };
      krile = {
        user = "deck";
        hostname = "krile.tail08e9a.ts.net";
      };
      # tailscale stuff with fixed usernames
      thancred = {
        user = "ihaveahax";
        hostname = "thancred.tail08e9a.ts.net";
      };
      homeserver = {
        user = "ihaveahax";
        hostname = "homeserver.tail08e9a.ts.net";
      };
      alphinaud = {
        user = "ianburgwin";
        hostname = "alphinaud.tail08e9a.ts.net";
      };
      tataru = {
        user = "ihaveahax";
        hostname = "tataru.tail08e9a.ts.net";
      };
    };
  };
}
