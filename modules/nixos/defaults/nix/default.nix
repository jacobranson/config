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
in 
{
  options.internal.defaults.nix = with types; {};

  config = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    nix = {
      # ref: https://mynixos.com/nixpkgs/options/nix

      channel.enable = false;

      # Populate Nix channels with this flake's nixpkgs revision only.
      # Ensures that legacy Nix CLI commands can and only use this flake's instance of Nixpkgs.
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

      settings = {
        # ref: https://nixos.org/manual/nix/unstable/command-ref/conf-file.html#available-settings

        # enable flakes
        experimental-features = [ "nix-command" "flakes" ];
      };
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It's perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?
  };
}
