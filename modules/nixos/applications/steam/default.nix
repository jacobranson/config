{ config, lib, ... }:

with lib;
with lib.internal;

# refs:
#   - https://steamcommunity.com/sharedfiles/filedetails/?id=2615011323

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
        ENABLE_VKBASALT = "1";
        MANGOHUD = "1";
      };
    };
  };
}
