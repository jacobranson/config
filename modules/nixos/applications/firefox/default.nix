{ config, lib, pkgs, ... }:

with lib;
with lib.internal;

let
  cfg = config.internal.applications.firefox;
in {
  options.internal.applications.firefox = with types; {
    enable = mkBoolOpt' false;
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-esr;
      policies = {
        DisablePocket = true;
        DisableFirefoxStudies = true;
        DisableProfileImport = true;
        DisplayBookmarksToolbar = "always";
        NoDefaultBookmarks = true;
        ManagedBookmarks = (import ./bookmarks.nix);
        Preferences = (import ./preferences.nix);
        SearchEngines = {
          PreventInstalls = true;
          Default = "DuckDuckGo";
          Remove = [
            "Google"
            "Amazon.com"
            "Bing"
            "eBay"
            "Wikipedia (en)"
          ];
        };
        SearchSuggestEnabled = true;
        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
          Locked = true;
        };
        FirefoxHome = {
          Search = true;
          TopSites = false;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = false;
          Locked = true;
        };
        Containers = {
          Default = [
            {
              "name" = "Studio Waxwing (Personal)";
              "icon" = "circle";
              "color" = "turquoise";
            }
            {
              "name" = "Studio Waxwing (Admin)";
              "icon" = "circle";
              "color" = "red";
            }
          ];
        };
        CaptivePortal = false;
        DisableFirefoxAccounts = true;
        DisableFirefoxScreenshots = true;
        DisableFormHistory = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        GoToIntranetSiteForSingleWordEntryInAddressBar = false;
        HardwareAcceleration = true;
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;
        PromptForDownloadLocation = false;
        ShowHomeButton = false;
        Homepage = {
          Locked = true;
          StartPage = "homepage";
          URL = "about:home";
        };
        ExtensionSettings = (import ./extensions.nix);
      };
    };

    xdg.mime.defaultApplications = {
      "text/html" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };

    internal.features.impermanence.userDirectories = [ ".mozilla" ];
  };
}
