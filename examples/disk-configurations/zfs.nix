{ config, inputs, pkgs, ... }:

let
  disk = "nvme0n1";
  espSize = "512M";
  swapSize = "32G";
in {
  disko.devices = {
    disk = {
      "${disk}" = {
        type = "disk";
        device = "/dev/${disk}";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "${espSize}";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            swap = {
              size = "${swapSize}";
              content = {
                type = "swap";
                resumeDevice = true;
                randomEncryption = true;
                priority = 100;
              };
            };
            root = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions.canmount = "off";
        postCreateHook = "(zfs list -t snapshot -H -o name | grep -E '^zroot/encrypted/root@blank$' || zfs snapshot zroot/encrypted/root@blank) && (zfs list -t snapshot -H -o name | grep -E '^zroot/encrypted/home@blank$' || zfs snapshot zroot/encrypted/home@blank)";
        datasets = {
          "encrypted" = {
            type = "zfs_fs";
            options.mountpoint = "none";
            options.encryption = "aes-256-gcm";
            options.keyformat = "passphrase";
            options.keylocation = "file:///tmp/nvme0n1.key";
            postCreateHook = ''
              zfs set keylocation="prompt" "zroot/$name";
            '';
          };
          "encrypted/root" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/";
          };
          "encrypted/home" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/home";
          };
          "encrypted/nix" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/nix";
          };
          "encrypted/persist" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/persist";
          };
        };
      };
    };
  };
  fileSystems = {
    "/".neededForBoot = true;
    "/nix".neededForBoot = true;
    "/home".neededForBoot = true;
    "/boot".neededForBoot = true;
    "/persist".neededForBoot = true;
  };
  internal.filesystems.zfs.enable = true;
  # boot.initrd.secrets."/tmp/nvme0n1.key" = null;
}
