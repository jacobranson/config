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

# Upstream Steam-Related Issues
#   - New steam UI does not open if run with DRI_PRIME=1
#     - https://github.com/ValveSoftware/steam-for-linux/issues/9383
#   - Steam client does not use GNOME's display scaling (TODO fixed on Steam Beta?)
#     - https://github.com/ValveSoftware/steam-for-linux/issues/5460#issuecomment-2253588058

# NixOS Steam-Related Issues
#   - (Packaging Request) Steam Link
#     - https://github.com/NixOS/nixpkgs/issues/77026
#   - (Packaging Request) SteamPlay Compatibility Tools: Proton-GE, Boxtron, Roberta, Luxtorpeda
#     - https://github.com/NixOS/nixpkgs/issues/73323
#   - (Packaging Request) Nyrna
#     - https://github.com/NixOS/nixpkgs/issues/212079

# About Steam Tinker Launch
#   - https://github.com/sonic2kk/steamtinkerlaunch
#   - https://github.com/sonic2kk/steamtinkerlaunch?tab=readme-ov-file#how-do-i-use-it
#   - https://github.com/sonic2kk/steamtinkerlaunch/wiki
#   - https://github.com/sonic2kk/steamtinkerlaunch/wiki/Installation#optional-dependencies
#   - https://gist.github.com/jakehamilton/632edeb9d170a2aedc9984a0363523d3

# About Touhou Community Reliant Automatic Patcher (thcrap)
#   - https://github.com/thpatch/thcrap
#   - https://github.com/tactikauan/thcrap-steam-proton-wrapper
#   - https://github.com/tactikauan/thcrap-steam-proton-wrapper?tab=readme-ov-file#how-to-use

# `steam-run bash` might let you explore the steam environment

let
  cfg = config.internal.applications.steam;
in {
  options.internal.applications.steam = with types; {
    enable = mkBoolOpt' false;
  };

  config = mkIf cfg.enable {

    programs.steam = {
      enable = true;

      package = pkgs.steam.override {
        # withPrimus = true;
        # withJava = true;

        # TODO is this needed? - export STEAM_FORCE_DESKTOPUI_SCALING=2
        extraProfile = ''
          export JAVA_HOME=${pkgs.jdk.home}/lib/openjdk
        '';
        extraBwrapArgs = [
          "--chdir ~ --bind ~/Games ~"
        ];

        extraPkgs = pkgs: with pkgs; [
          steamtinkerlaunch thcrap-steam-proton-wrapper jdk

          # Steam Tinker Launch mandatory dependencies
          gawk bash git gnumake procps unzip wget xdotool
          xorg.xprop xorg.xrandr vim-full xorg.xwininfo yad

          # Steam Tinker Launch optional dependencies
          gdb imagemagick jq libnotify mangohud nettools p7zip pev
          rsync scummvm strace usbutils vkbasalt wine winetricks xdg-utils

          # Steam Tinker Launch missing optional dependencies
          # boxtron nyrna vr-video-player
        ];
      };

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;

      gamescopeSession.enable = true;
      extest.enable = true;
    };

    # Steam Tinker Launch optional dependencies
    programs.gamemode.enable = true;
    programs.gamescope.enable = true;

    # Steam Link isn't packaged in Nix
    internal.features.flatpak.packages = [{
      appId = "com.valvesoftware.SteamLink";
      origin = "flathub";
    }];

    system.userActivationScripts.makeSteamSymlinks.text = ''
      ln -sfh ~/Games/.local/share/Steam/ ~/.local/share/Steam
      ln -sfh ~/Games/.steam ~/.steam

      mkdir -p $STEAM_EXTRA_COMPAT_TOOL_PATHS/SteamTinkerLaunch
		  ln -sfn ${pkgs.steamtinkerlaunch}/bin/steamtinkerlaunch $STEAM_EXTRA_COMPAT_TOOL_PATHS/SteamTinkerLaunch/steamtinkerlaunch
    '';

    internal.features.impermanence.userDirectories = [
      "Games" "stl"
    ];

    environment.systemPackages = with pkgs; [
      steam-run # or (steam.override { /* Your overrides here */ }).run
    ];
  };
}
