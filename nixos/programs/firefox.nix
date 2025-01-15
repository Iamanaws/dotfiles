{ lib, ... }: 

{
  programs.firefox = {
    enable = true;

    policies = {
      Cookies.Behavior = "reject-foreign";
      DisableAppUpdate = true;
      DisableFirefoxStudies = true;
      DisableMasterPasswordCreation = true;
      DisablePocket = true;
      DisableProfileImport = true;
      DisableSetDesktopBackground = true;
      DisableTelemetry = true;
      DisplayBookmarksToolbar = "newtab";

      DNSOverHTTPS = {
        Enabled = true;
        Fallback = true;
      };

      DontCheckDefaultBrowser = true;

      EnableTrackingProtection = {
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
        Locked = false;
        Value = true;
      };

      EncryptedMediaExtensions = {
        Enabled = true;
        Locked = false;
      };

      FirefoxHome = {
        Highlights = false;
        Locked = false;
        Pocket = false;
        Search = true;
        Snippets = false;
        SponsoredPocket = false;
        SponsoredTopSites = false;
        TopSites = false;
      };

      FirefoxSuggest = {
        ImproveSuggest = false;
        Locked = false;
        SponsoredSuggestions = false;
        WebSuggestions = false;
      };

      HardwareAcceleration = true;

      Homepage = {
        Locked = false;
        StartPage = "previous-session";
      };

      NewTabPage = false;
      NoDefaultBookmarks = false; # Enabling this prevents declaratively setting bookmarks.
      OfferToSaveLoginsDefault = false;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";

      PDFjs = {
        Enabled = true;
        EnablePermissions = false;
      };

      Preferences = {
        "browser.aboutConfig.showWarning" = false;
        "browser.bookmarks.addedImportButton" = false;
        "browser.compactmode.show" = true;
        "browser.download.always_ask_before_handling_new_types" = true;
        "browser.download.panel.shown" = true;
        "browser.uidensity" = 1;
        
        "browser.urlbar.shortcuts.bookmarks" = false;
        "browser.urlbar.shortcuts.history" = false;
        "browser.urlbar.shortcuts.tabs" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.suggest.topsites" = false;

        "datareporting.policy.dataSubmissionPolicyAccepted" = false;
        "dom.security.https_only_mode" = true;
        "extensions.autoDisableScopes" = 0;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.navigator.mediadatadecoder_vpx_enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
      };

      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        MoreFromMozilla = false;
        SkipOnboarding = true;
      };

      UseSystemPrintDialog = true;
    };
  };
}