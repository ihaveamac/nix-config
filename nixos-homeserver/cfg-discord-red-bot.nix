{
  config,
  lib,
  pkgs,
  me,
  ...
}:

{
  virtualisation.oci-containers.containers.redbot-gbatemp = {
    image = "ianburgwin/red-discordbot:latest";
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
