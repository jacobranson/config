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
  cfg = config.internal.desktops.gnome;
in 
{
  options.internal.desktops.gnome = with types; {
    enable = mkBoolOpt' false;
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer']
    '';

    services.libinput.enable = true;
    services.switcherooControl.enable = true;

    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;
    internal.features.impermanence.userDirectories = [
      ".local/share/keyrings"
    ];

    services.xserver.excludePackages = [ pkgs.xterm ];
    environment.gnome.excludePackages = with pkgs; [
      # replaced apps
      gnome-music       # replaced by amberol
      totem                   # replaced by clapper
      epiphany                # replaced by firefox
      gnome-system-monitor    # replaced by mission-center
      seahorse                # replaced by app.drey.KeyRack

      # extraneous apps
      gnome-tour                    # GNOME Welcome app
      yelp                          # GNOME Help app
      gnome-shell-extensions  # default extensions
      gnome-contacts
      gnome-weather
      gnome-clocks
      gnome-maps
    ];

    environment.systemPackages = with pkgs; [
      # replacement apps
      amberol                  # replaces gnome-music
      clapper                  # replaces totem
      gnome-extension-manager  # replaces gnome-shell-extensions
      mission-center           # replaces gnome-system-monitor
      key-rack                 # replaces seahorse

      # extra apps
      gnomeExtensions.appindicator  # for system tray support
      kooha                         # for screen recording
    ];

    xdg.portal.enable = true;
    xdg.portal.xdgOpenUsePortal = true;

    programs.dconf = (import ./dconf.nix { inherit lib; } );
  };
}
