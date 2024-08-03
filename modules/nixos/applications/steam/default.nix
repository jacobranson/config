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

# also see overlays/steam/default.nix

let
  cfg = config.internal.applications.steam;
in {
  options.internal.applications.steam = with types; {
    enable = mkBoolOpt' false;
  };

  config = mkIf cfg.enable {

    programs.steam = {
      enable = true;

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;

      gamescopeSession.enable = true;
      extest.enable = true;
    };

    programs.gamemode.enable = true;
    programs.gamescope.enable = true;

    # Steam Link isn't packaged in Nix, so use the official Flatpak
    internal.features.flatpak.packages = [{
      appId = "com.valvesoftware.SteamLink";
      origin = "flathub";
    }];

    system.userActivationScripts.makeSteamSymlinks.text = ''
      ln -sfn ~/Games/.local/share/Steam/ ~/.local/share/Steam
      ln -sfn ~/Games/.steam ~/.steam
    '';

    internal.features.impermanence.userDirectories = [
      "Games"
    ];

    environment.systemPackages = with pkgs; [
      steam-run # or (steam.override { /* Your overrides here */ }).run
    ];
  };
}
