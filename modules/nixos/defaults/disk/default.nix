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
  cfg = config.internal.defaults.disk;
in
{
  options.internal.defaults.disk = with types; {
    disk = mkStrOpt' null; # nvme0n1
    espSize = mkStrOpt' "512M";
    swapSize = mkStrOpt' "8G";
    layout = mkStrOpt' "luks-lvm-btrfs"; # or zfs
  };

  config = (mkMerge [
    (mkIf (cfg.layout == "luks-lvm-btrfs") (
      import ./layouts/luks-lvm-btrfs.nix {
        inherit (cfg) disk espSize swapSize;
    }))
    (mkIf (cfg.layout == "zfs") (
      import ./layouts/zfs.nix {
        inherit (cfg) disk espSize swapSize;
    }))
  ]);
}
