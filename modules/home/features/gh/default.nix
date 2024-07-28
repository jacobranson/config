{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,

  # Additional metadata is provided by Snowfall Lib.
  namespace, # The namespace used for your flake, defaulting to "internal" if not set.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.

  # All other arguments come from the module system.
  config,

  ...
}:

# The gh cli expects the config file to be writeable at all
# times. For this reason, do not add configurations to the
# cli via this module. Otherwise, when logging in, you will
# receive an error about not being able to write to config.yaml,
# since it is in the readonly Nix store.
#
# In order to login to the gh cli, you will need a credentials
# manager. If you don't have one, the cli will dump your secrets
# into the config folder in plain text.
#
# On GNOME, this option must be enabled: "services.gnome.gnome-keyring.enable".
# To auto-unlock the keyring: "security.pam.services.gdm.enableGnomeKeyring";
# Finally, be sure the keyrings folder for your user is persisted:
# internal.features.impermanence.userDirectories = [
#   ".local/share/keyrings"
# ];

with builtins;
with lib;
with lib.internal;

let
  cfg = config.internal.features.gh;
in {
  options.internal.features.gh = with types; {
    enable = mkBoolOpt' false;
  };

  config = mkIf cfg.enable {
    # prefer the package over the module since
    # gh likes to manage its own config imperatively.
    home.packages = [ pkgs.gh ];

    internal.features.impermanence.directories = [
      ".config/gh"
    ];
  };
}
