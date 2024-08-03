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

# Upstream Steam-Related Issues
#   - New steam UI does not open if run with DRI_PRIME=1
#     - https://github.com/ValveSoftware/steam-for-linux/issues/9383

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

# `steam-run bash` lets you explore the steam environment

final: prev: {
  steam = prev.steam.override {
    extraProfile = let
      compatibilitytool = (readFile ./compatibilitytool.vdf);
      toolmanifest = (readFile ./toolmanifest.vdf);
    in ''
      stlpath=~/.local/share/Steam/compatibilitytools.d/SteamTinkerLaunch
      mkdir -p $stlpath

      if ! [ -L $stlpath/steamtinkerlaunch ]; then
        ln -sfn ${prev.steamtinkerlaunch}/bin/steamtinkerlaunch $stlpath/steamtinkerlaunch
      fi

      if ! [ -f $stlpath/compatibilitytool.vdf ]; then
        cat > $stlpath/compatibilitytool.vdf << EOL
          ${compatibilitytool}
        EOL
      fi

      if ! [ -f $stlpath/toolmanifest.vdf ]; then
        cat > $stlpath/toolmanifest.vdf << EOL
          ${toolmanifest}
        EOL
      fi

      export JAVA_HOME=${prev.jdk.home}/lib/openjdk
    '';
    extraBwrapArgs = [
      "--bind ~/Games ~"
    ];

    extraPkgs = pkgs: with prev; [
      steamtinkerlaunch thcrap-steam-proton-wrapper jdk

      # Steam Tinker Launch mandatory dependencies
      gawk bash git gnumake procps unzip wget xdotool
      xorg.xprop xorg.xrandr vim-full xorg.xwininfo yad

      # Steam Tinker Launch optional dependencies
      gdb imagemagick jq libnotify mangohud nettools p7zip pev
      rsync scummvm strace usbutils vkbasalt wine winetricks xdg-utils

      # Steam Tinker Launch missing optional dependencies
      # boxtron nyrna replay-sorcery vr-video-player 
    ];
  };
}
