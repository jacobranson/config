{ config, lib, pkgs, ... }:

with lib;
with lib.internal;

let
  cfg = config.internal.features.virtualisation;
in {
  options.internal.features.virtualisation = with types; {
    enable = mkBoolOpt' false;
    user = mkStrOpt' null;
    platform = mkStrOpt' "amd";
    vfioIds = mkOpt' anything [];
  };

  config = mkIf cfg.enable {
    boot = {
      kernelModules = [ "kvm-${cfg.platform}" "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
      kernelParams = [ "${cfg.platform}_iommu=on" "${cfg.platform}_iommu=pt" "kvm.ignore_msrs=1" ];
      extraModprobeConfig = "options vfio-pci ids=${builtins.concatStringsSep "," cfg.vfioIds}";
    };

    systemd.tmpfiles.rules = [
        "f /dev/shm/looking-glass 0660 ${cfg.user} qemu-libvirtd -"
    ];

    environment.systemPackages = with pkgs; [
        looking-glass-client
        pciutils
    ];

    programs.virt-manager.enable = true;

    virtualisation = {
      libvirtd = {
        enable = true;
        extraConfig = ''
          user="${cfg.user}"
        '';

        onBoot = "ignore";
        onShutdown = "shutdown";

        qemu = {
          package = pkgs.qemu_kvm;
          ovmf.enable = true;
          verbatimConfig = ''
            namespaces = []
            user = "+${builtins.toString config.users.users.${cfg.user}.uid}"
          '';
        };
      };
    };

    users.users.${cfg.user}.extraGroups = [ "qemu-libvirtd" "libvirtd" "disk" ];

    internal.features.impermanence = {
      directories = [
        "/var/lib/libvirt"
      ];
      userDirectories = [
        ".config/libvirt"
        ".local/share/libvirt"
      ];
    };
  };
}
