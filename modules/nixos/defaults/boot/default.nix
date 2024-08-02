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
  cfg = config.internal.defaults.boot;
  # hidpi = config.internal.features.hidpi; TODO remove this
in {

  options.internal.defaults.boot = with types; {
    secure-boot = mkBoolOpt' false;
    silent-boot = mkBoolOpt' false;
    skip-bootloader = mkBoolOpt' false;
  };

  # mkMerge ref: https://nixos.org/manual/nixos/stable/#sec-option-definitions-merging
  config = (mkMerge [
    ({
      boot.initrd.systemd.enable = true;
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      # secure boot configs are kept here in the common
      # module because secure-boot must be set to false
      # for the first system boot.

      # sbctl for debugging and troubleshooting Secure Boot.
      # tpm2-tss for interacting with the tpm secure enclave.
      environment.systemPackages = [ pkgs.sbctl pkgs.tpm2-tss ];

      # secureboot keys are generated manually after first boot
      # and stored here.
      internal.features.impermanence.directories = [ "/etc/secureboot" ];
    })
    (mkIf cfg.secure-boot {
      # Lanzaboote currently replaces the systemd-boot module.
      # This setting is usually set to true in configuration.nix
      # generated at installation time. So we force it to false
      # for now.
      boot.loader.systemd-boot.enable = mkForce false;
      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/etc/secureboot";
      };
    })
    (mkIf cfg.silent-boot {
      # hides boot logs behind a loading screen
      boot.plymouth.enable = true;
      # boot.plymouth.extraConfig = (mkIf hidpi.enable "DeviceScale=2"); TODO test if this is necessary
      
      # hacky way to make the system boot without showing logs.
      # can be overridden by pressing "Escape".
      boot.kernelParams = [ "quiet" ];
      boot.initrd.verbose = false;
      boot.consoleLogLevel = 0;
    })
    (mkIf cfg.skip-bootloader {
      # hide the nixos generation boot selection menu by default.
      # can be overridden by holding "Space".
      boot.loader.timeout = 0;
    })
  ]);
}
