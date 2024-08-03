# Snowfall Lib provides access to additional information via a primary argument of
# your overlay.
{
  # Channels are named after NixPkgs instances in your flake inputs. For example,
  # with the input `nixpkgs` there will be a channel available at `channels.nixpkgs`.
  # These channels are system-specific instances of NixPkgs that can be used to quickly
  # pull packages into your overlay.
  channels,

  # Inputs from your flake.
  inputs,

  ...
}:

final: prev: {
  # For example, to pull a package from unstable NixPkgs make sure you have the
  # input `unstable = "github:nixos/nixpkgs/nixos-unstable"` in your flake.
  # Then, uncomment the following line:
  # inherit (channels.unstable) chromium;
  #
  # Or, to add a package that is not in Nixpkgs currently via an external flake:
  # my-package = inputs.my-input.packages.${prev.system}.my-package;

  steam = prev.steam.override {
    extraProfile = ''
      export STEAM_EXTRA_COMPAT_TOOL_PATHS=${pkgs.steamtinkerlaunch}/bin
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
}
