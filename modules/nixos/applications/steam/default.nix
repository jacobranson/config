{ config, lib, ... }:

with lib;
with lib.internal;

# opt-in to the Steam Beta

# refs:
#   - https://steamcommunity.com/sharedfiles/filedetails/?id=2615011323
#   - https://github.com/ValveSoftware/steam-for-linux/issues/5460#issuecomment-2253588058

let
  cfg = config.internal.applications.steam;
in {
  options.internal.applications.steam = with types; {
    enable = mkBoolOpt' false;
  };

  config = mkIf cfg.enable {
    internal.features.flatpak.packages = [
      "com.valvesoftware.Steam"
      "com.valvesoftware.Steam.CompatibilityTool.Boxtron"
      "com.valvesoftware.Steam.Utility.protontricks"
      "com.valvesoftware.SteamLink"
      "org.freedesktop.Platform.VulkanLayer.MangoHud"
      "org.freedesktop.Platform.VulkanLayer.vkBasalt"
      "com.valvesoftware.Steam.Utility.gamescope"
      "net.davidotek.pupgui2"
    ];

    services.flatpak.overrides."com.valvesoftware.Steam" = {
      Environment = {
        # STEAM_FORCE_DESKTOPUI_SCALING = "2.0"; # TODO maybe unneeded with latest beta
        ENABLE_VKBASALT = "1";
        MANGOHUD = "1";
      };
    };
  };
}
