{ config, lib, ... }:

with lib;
with lib.internal;

# opt-in to the Steam Beta

# refs:
#   - https://steamcommunity.com/sharedfiles/filedetails/?id=2615011323
#   - https://github.com/ValveSoftware/steam-for-linux/issues/5460#issuecomment-2253588058

let
  cfg = config.internal.applications.nixos-conf-editor;
in {
  options.internal.applications.nixos-conf-editor = with types; {
    enable = mkBoolOpt' false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nixos-conf-editor
    ];
  };
}
