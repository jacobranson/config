let
  mkUserPref = default: {
    "Value" = default;
    "Status" = "default";
  };
in
{
  "browser.aboutConfig.showWarning" = mkUserPref false;
  "browser.urlbar.suggest.topsites" = mkUserPref false;
  "browser.tabs.tabmanager.enabled" = mkUserPref false;
  "browser.tabs.firefox-view" = mkUserPref false;
}
