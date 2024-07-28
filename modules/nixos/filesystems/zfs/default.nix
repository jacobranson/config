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
  cfg = config.internal.filesystems.zfs;
  impermanence = config.internal.features.impermanence;
in {

  options.internal.filesystems.zfs = with types; {
    enable = mkBoolOpt' false;
  };

  config = mkIf cfg.enable (mkMerge [
    ({
      boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
      boot.supportedFilesystems = [ "zfs" ];
      boot.initrd.supportedFilesystems = [ "zfs" ];
      boot.zfs.allowHibernation = false;
    })
    (mkIf impermanence.enable {
      boot.initrd.systemd.services.rollback = {
        description = "Rollback root filesystem to a pristine state on boot";
        wantedBy = [ "initrd.target" ];
        after = [ "zfs-import-zroot.service" ]; # zroot is the name of our root zpool.
        before = [ "sysroot.mount" ]; # sysroot is a default mount defined by systemd. do not change.
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        path = with pkgs; [ zfs ];
        script = ''
          zfs rollback -r zroot/encrypted/root@blank
          zfs rollback -r zroot/encrypted/home@blank
        '';
      };
    })
  ]);
}
