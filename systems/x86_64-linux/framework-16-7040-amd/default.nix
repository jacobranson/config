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

  # All other arguments come from the system system.
  config,

  ...
}:

let
  secrets = config.age.secrets;
  ssh = config.internal.defaults.ssh;
in {
  imports = [ ./hardware-configuration.nix ];

  age.secrets = {
    "users/root/password" = {
      file = ./secrets/users/root/password.age;
    };
    "users/jacobranson/password" = {
      file = ./secrets/users/jacobranson/password.age;
    };
    "users/jacobranson/id_ed25519" = {
      file = ./secrets/users/jacobranson/id_ed25519.age;
    };
  };

  internal.defaults.disk = {
    disk = "nvme0n1";
    swapSize = "32G";
  };

  internal.defaults.boot = {
    secure-boot = true;
    silent-boot = true;
    skip-bootloader = true;
  };

  internal.defaults.networking = {
    hostname = "framework-16-7040-amd";
    machineid = "b29fbee53c6543c1ab9edd6c378fb880";
  };

  internal.defaults.users.users = {
    "root" = {
      hashedPasswordFile = secrets."users/root/password".path;
    };

    "jacobranson" = {
      isNormalUser = true;
      hashedPasswordFile = secrets."users/jacobranson/password".path;
      extraGroups = [ "wheel" "networkmanager" ];
      openssh.authorizedKeys.keys = [
        ssh.public-keys.users."jacobranson@macbook-air-m1"
      ];
    };
  };

  internal.features.impermanence.enable = true;

  internal.desktops.gnome.enable = true;
  internal.features.hidpi.enable = true;
  internal.features.pipewire.enable = true;
  internal.features.fwupd.enable = true;
  internal.features.fprintd.enable = true;

  internal.features.flatpak = {
    enable = true;

    packages = [
      "io.gitlab.librewolf-community"
    ];
  };

  internal.features.just.enable = true;
  internal.features.nh = {
    enable = true;
    flake = "/home/jacobranson/Projects/config";
  };
}
