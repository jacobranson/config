{
  lib,
  pkgs,
  inputs,


  config,

  ...
}:

with builtins;
with lib;
with lib.internal;

let
  cfg = config.internal.filesystems.btrfs;
  impermanence = config.internal.features.impermanence;
in {

  options.internal.filesystems.btrfs = with types; {
    enable = mkBoolOpt' false;
  };

  config = mkIf cfg.enable (mkMerge [
    ({
      services.btrfs.autoScrub = {
        enable = true;
        interval = "monthly";
        fileSystems = [ "/" ];
      };
    })
    (mkIf impermanence.enable {
      boot.initrd.systemd.services.rollback = {
        description = "Rollback root filesystem to a pristine state on boot";
        wantedBy = [ "initrd.target" ];
        after = [ "systemd-cryptsetup@crypted.service" ]; # crypted is the name of our luks partition
        before = [ "sysroot.mount" ]; # sysroot is a default mount defined by systemd. do not change.
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          vgchange -ay root_vg
          mkdir -p /btrfs_tmp
          mount /dev/root_vg/root /btrfs_tmp
          if [[ -e /btrfs_tmp/root ]]; then
              mkdir -p /btrfs_tmp/old_roots
              timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
              mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
          fi

          delete_subvolume_recursively() {
              IFS=$'\n'
              for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                  delete_subvolume_recursively "/btrfs_tmp/$i"
              done
              btrfs subvolume delete "$1"
          }

          for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
              delete_subvolume_recursively "$i"
          done

          btrfs subvolume create /btrfs_tmp/root
          umount /btrfs_tmp
        '';
      };
    })
  ]);
}
