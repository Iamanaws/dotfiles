{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.mac-app-util.darwinModules.default
    ./homebrew.nix
    ./nix.nix
  ];

  power.sleep = {
    # minutes before sleep
    computer = 15;
    display = 5;
  };

  system.defaults = {
    ".GlobalPreferences"."com.apple.mouse.scaling" = 5.0;

    NSGlobalDomain = {
      AppleEnableMouseSwipeNavigateWithScrolls = false;
      AppleEnableSwipeNavigateWithScrolls = false;
      AppleICUForce24HourTime = false;
      # AppleInterfaceStyle = Dark;
      AppleInterfaceStyleSwitchesAutomatically = false;
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = 1;
      ApplePressAndHoldEnabled = true;
      AppleScrollerPagingBehavior = true;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = false;
      AppleShowScrollBars = "Automatic";
      AppleSpacesSwitchOnActivate = true;
      AppleTemperatureUnit = "Celsius";
      InitialKeyRepeat = 30;
      KeyRepeat = 5;
      NSDocumentSaveNewDocumentsToCloud = false;
      # "com.apple.trackpad.enableSecondaryClick" = true;
      "com.apple.trackpad.forceClick" = true;
      "com.apple.trackpad.scaling" = 3.0;
    };

    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

    controlcenter = {
      AccessibilityShortcuts = "hide";
      AirDrop = false;
      Battery = "menuBar";
      BatteryShowEnergyMode = "whenActive";
      BatteryShowPercentage = false;
      Bluetooth = false;
      Display = "whenActive";
      FocusModes = "whenActive";
      Hearing = "hide";
      KeyboardBrightness = "hide";
      MusicRecognition = "hide";
      NowPlaying = "whenActive";
      ScreenMirroring = "whenActive";
      Sound = "whenActive";
      StageManager = false;
      UserSwitcher = "hide";
      WiFi = false;
    };

    Spotlight.MenuItemHidden = true;

    loginwindow = {
      GuestEnabled = false;
    };

    menuExtraClock = {
      ShowAMPM = true;
      ShowDate = 0;
      ShowDayOfWeek = true;
    };

    spaces.spans-displays = true;

    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 5;
    };
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    alt-tab-macos
    # brave
    # ghostty # broken on nixpkgs, use brew cask
    iina
    rectangle

    bottom
    fet-sh
    neofetch
    neovim
    zstd
  ];

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
}
