{ config, lib, ... }:

with lib;
with lib.internal;

let
  cfg = config.internal.applications.steam;
in {
  options.internal.applications.steam = with types; {
    enable = mkBoolOpt' false;
  };

  config = mkIf cfg.enable {
    programs.steam.enable = true;

    system.userActivationScripts.makeSteamSymlinks.text = ''
      ln -sfn ~/Steam/.local/share/Steam/ ~/.local/share/Steam
      ln -sfn ~/Steam/.steam ~/.steam
    '';

    internal.features.impermanence.userDirectories = [ "Steam" ];
  };
}
