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

# Necessary System State
#
#   /nix
#   /boot
#   /var/lib/nixos
#   /etc/{passwd,group,shadow,gshadow,subuid,subgid}
#     (OR set `users.mutableUsers = false`)
#   /etc/machine-id
#   /var/lib/systemd
#   /var/log/journal
#   /etc/zfs
#     (only if using the zfs file system)
#
# ref: https://nixos.org/manual/nixos/stable/#ch-system-state

with builtins;
with lib;
with lib.internal;

let
  cfg = config.internal.features.impermanence;
  users = config.internal.defaults.users.users;

  defaultDirectories = [
    "/var/lib/nixos"
    "/var/lib/systemd"
    "/var/log/journal"
  ];
  defaultFiles = [];
  defaultUserDirectories = [
    "Desktop"
    "Documents"
    "Downloads"
    "Music"
    "Pictures"
    "Projects"
    "Public"
    "Templates"
    "Videos"
    "Games"
  ];
  defaultUserFiles = [];
in 
{
  options.internal.features.impermanence = with types; {
    enable = mkBoolOpt' false;
    persist = mkStrOpt' "/persist";

    directories = mkOpt' (listOf anything) [];
    files = mkOpt' (listOf anything) [];
    userDirectories = mkOpt' (listOf anything) [];
    userFiles = mkOpt' (listOf anything) [];
  };

  config = mkIf cfg.enable {
    users.mutableUsers = false;
    programs.fuse.userAllowOther = true;
    fileSystems."${cfg.persist}".neededForBoot = true;
    environment.persistence."${cfg.persist}" = {
      hideMounts = true;
      directories = cfg.directories ++ defaultDirectories;
      files = cfg.files ++ defaultFiles;
      users = (
        (
          users: value:
              let acc = {}; in
              builtins.foldl'
                (acc: user: acc // { "${user}" = value; })
                acc
                (filter
                  (e: e != "root" && users."${e}".isNormalUser == true)
                  (mapAttrsToList (name: _: name) users))
        )
        users
        {
          directories = cfg.userDirectories ++ defaultUserDirectories;
          files = cfg.userFiles ++ defaultUserFiles;
        }
      );
    };
  };
}
