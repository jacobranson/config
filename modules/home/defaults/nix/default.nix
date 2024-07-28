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

let
  cfg = config.internal.defaults.nix;
in {
  options.internal.defaults.nix = with types; {
    username = mkStrOpt' "jacobranson";
    version = mkStrOpt' "24.05";
  };

  config = {
    home.username = cfg.username;
    home.homeDirectory = (
      if (hasInfix "darwin" system)
      then "/Users/${cfg.username}"
      else "/home/${cfg.username}"
    );
    home.stateVersion = cfg.version;
    home.activation.cleanup-nix = hm.dag.entryAfter ["writeBoundary"] ''
      rm -rf ~/.nix-defexpr
      rm -rf ~/.nix-profile
    '';
  };
}
