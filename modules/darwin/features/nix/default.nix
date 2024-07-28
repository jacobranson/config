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
  cfg = config.internal.features.nix;
in 
{
  options.internal.features.nix = with types; {
    enable = mkBoolOpt' true;
    packages = mkOpt' (listOf anything) [];
  };

  config = mkIf cfg.enable {
    inputs.home-manager.useGlobalPkgs = true;
    inputs.home-manager.useUserPackages = true;

    nix = {
      # ref: https://mynixos.com/nixpkgs/options/nix

      enable = cfg.enable;

      # Populate Nix channels with this flake's nixpkgs revision only.
      # Ensures that legacy Nix CLI commands can and only use this flake's instance of Nixpkgs.
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

      settings = {
        # ref: https://nixos.org/manual/nix/unstable/command-ref/conf-file.html#available-settings

        # enable flakes
        experimental-features = [ "nix-command" "flakes" ];
      };
    };
  };
}
