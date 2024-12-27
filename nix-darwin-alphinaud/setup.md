To set up on a new mac:

* Update "me" in flake.nix and darwin-configuration.nix
* make sure Terminal has full disk access
* install Command Line Tools + brew
* install Rosetta 2: `softwareupdate --install-rosetta`
* set system security to Reduced Security + user management of kernel extensions
* install macfuse through brew first (or save3ds will fail)
* in etc, move `nix/nix.conf`, `zprofile`, `zshenv`, and `zshrc` out of the way
