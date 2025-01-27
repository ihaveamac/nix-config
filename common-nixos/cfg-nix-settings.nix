{
  config,
  lib,
  pkgs,
  me,
  ...
}:

{
  nix.settings = {
    # needed for cachix and linux-builder
    # root is assumed to be here
    trusted-users = [ "${me}" ];
  };
}
