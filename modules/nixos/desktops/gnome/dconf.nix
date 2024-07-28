{ lib, ... }:

with lib;
with lib.internal;

let
  backgrounds = "file:///run/current-system/sw/share/backgrounds/gnome";
  # dconf settings to apply to both gdm and normal users
  dconf-common = {
    "org/gnome/desktop/interface" = {
      scaling-factor = gvariant.mkUint32 2;
      clock-format = "12h";
      show-battery-percentage = true;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
    };
  };
in {
  enable = true;

  profiles = {
    gdm.databases = [{ settings = dconf-common; }];
    user.databases = [{
      # `just watch-dconf` is useful for finding these
      settings = (recursiveUpdate dconf-common {
        "org/gtk/settings/file-chooser" = {
          clock-format = "12h";
        };
        "org/gnome/mutter" = {
          center-new-windows = true;
          edge-tiling = true;
          dynamic-workspaces = true;
          workspaces-only-on-primary = true;
        };
        "org/gnome/shell" = {
          # `just show-desktop-files` is useful for finding these
          favorite-apps = [
            "firefox.desktop"
            "org.gnome.Nautilus.desktop"
            "org.gnome.Console.desktop"
            "io.missioncenter.MissionCenter.desktop"
            "org.gnome.Software.desktop"
          ];
          disable-user-extensions = false;
          # `just show-gnome-extensions` to get a list of these!
          enabled-extensions = [
            "appindicatorsupport@rgcjonas.gmail.com"
          ];
        };
        "org/gnome/shell/app-switcher" = {
          current-workspace-only = true;
        };
        "org/gnome/desktop/interface" = {
          gtk-theme = "Adwaita-dark";
          color-scheme = "prefer-dark";
        };
        "org/gnome/desktop/background" = {
          picture-uri = "${backgrounds}/blobs-l.svg";
          picture-uri-dark = "${backgrounds}/blobs-d.svg";
          primary-color = "#241f31";
        };
        "org/gnome/desktop/screensaver" = {
          picture-uri = "${backgrounds}/blobs-l.svg";
          primary-color = "#241f31";
        };
        "org/gnome/desktop/wm/keybindings" = {
          close = ["<Super>q"];
          switch-applications = ["<Super>Tab"];
          switch-applications-backward = ["<Shift><Super>Tab"];
          switch-windows = ["<Alt>Tab"];
          switch-windows-backward = ["<Shift><Alt>Tab"];
          switch-to-workspace-left = ["<Control><Super>Left"];
          switch-to-workspace-right = ["<Control><Super>Right"];
          move-to-workspace-left = ["<Shift><Control><Super>Left"];
          move-to-workspace-right = ["<Shift><Control><Super>Right"];
          toggle-fullscreen = ["<Super>Return"];
        };
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
          ];
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          name = "Mission Center";
          command = "missioncenter";
          binding = "<Super>w";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
          name = "Nautilus";
          command = "nautilus";
          binding = "<Super>e";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
          name = "Kooha";
          command = "kooha";
          binding = "<Super>r";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
          name = "Firefox";
          command = "firefox";
          binding = "<Super>b";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
          name = "Console";
          command = "kgx";
          binding = "<Super>t";
        };
        "org/gnome/desktop/wm/preferences" = {
          auto-raise = true;
          audible-bell = false;
          visual-bell = false;
        };
      });
    }];
  };
}
