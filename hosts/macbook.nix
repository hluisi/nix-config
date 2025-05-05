{ config, pkgs, lib, ... }:

{
  ###########################################################################
  # macOS Host: MacBook (Apple Silicon)
  ###########################################################################

  imports = [
    ../modules/homebrew.nix
  ];

  # Host-specific metadata
  networking.hostName = "macbook";
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Mac-specific packages (from original darwin flake)
  environment.systemPackages = with pkgs; [
    # Mac-specific GUI / utilities
    alacritty
    mkalias
    obsidian

    # Optional zsh plugins
    # zsh-autosuggestions
    # zsh-history
    # zsh-syntax-highlighting
  ];

  # Example Dock and Finder defaults (can be tweaked later)
  # Restore full macOS defaults from original configuration
  system.defaults = {
    dock.autohide = true;
    dock.autohide-delay = 0.15;
    dock.show-recents = false;
    dock.showhidden = true;

    dock.persistent-apps = [
      "/System/Applications/Launchpad.app"
      "/System/Applications/App Store.app"
      "/System/Applications/System Settings.app"
      "/System/Applications/Calculator.app"
      "/System/Applications/Messages.app"
      "/System/Applications/Mail.app"
      "/System/Applications/Calendar.app"
      "/Applications/Ghostty.app"
      "${pkgs.brave}/Applications/Brave Browser.app"
      "/System/Cryptexes/App/System/Applications/Safari.app"
      "/Applications/Signal.app"
      "/Applications/Wispr Flow.app"
      "/Applications/CleanMyMac_5_MAS.app"
      "${pkgs.vscode}/Applications/Visual Studio Code.app"
    ];

    finder.FXPreferredViewStyle = "clmv";
    loginwindow.GuestEnabled = false;

    # Locale & UI tweaks
    NSGlobalDomain.AppleICUForce24HourTime = true;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.KeyRepeat = 2;
  };
# Link Nix-installed macOS apps into /Applications/Nix Apps
  system.activationScripts.applications.text =
    let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = "/Applications";
      };
    in pkgs.lib.mkForce ''
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\\ Apps
      mkdir -p /Applications/Nix\\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';
  }