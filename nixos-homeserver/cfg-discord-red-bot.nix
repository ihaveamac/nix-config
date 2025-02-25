{
  config,
  lib,
  pkgs,
  me,
  ...
}:

let
  redbot-info = builtins.fromJSON (builtins.readFile ./redbot-info.json);
in
{
  virtualisation.oci-containers.containers.redbot-gbatemp = with redbot-info; {
    image = "${imagename}:${version}";
    cmd = [
      "redbot"
      "GBAtemp"
    ];
    volumes = [
      "/opt/docker/redbot/data-gbatemp:/data-gbatemp"
      "/opt/docker/redbot/config.json:/home/redbot/.config/Red-DiscordBot/config.json"
    ];
  };
}
