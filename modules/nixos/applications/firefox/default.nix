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
