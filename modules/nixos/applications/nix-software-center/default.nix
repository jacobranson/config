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

with builtins;
with lib;
with lib.internal;

# opt-in to the Steam Beta

# refs:
#   - https://steamcommunity.com/sharedfiles/filedetails/?id=2615011323
#   - https://github.com/ValveSoftware/steam-for-linux/issues/5460#issuecomment-2253588058

let
  cfg = config.internal.applications.nix-software-center;
in {
  options.internal.applications.nix-software-center = with types; {
    enable = mkBoolOpt' false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nix-software-center
    ];
  };
}
