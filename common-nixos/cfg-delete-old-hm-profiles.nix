# Home Manager creates profiles in local directories
# requiring me to use "nix-collect-garbage -d" at least twice
# as my user and as root to get them all
# we don't need them since Home Manager is managed with the NixOS system

{
  config,
  lib,
  pkgs,
  me,
  ...
}:

{
  systemd = {
    services.clean-up-home-manager = {
      path = [ config.nix.package ];
      script = ''
        for f in ${config.users.users.${me}.home}/.local/state/nix/profiles/home-manager /nix/var/nix/profiles/per-user/root/home-manager; do
          nix-env --profile $f --delete-generations old
        done
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };

    timers.clean-up-home-manager = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = [
          # i think this time should work as both central and UTC
          "*-*-* 08:00:00"
        ];
        Unit = "clean-up-home-manager.service";
      };
    };
  };
}
