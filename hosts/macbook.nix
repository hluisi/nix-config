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

  # Example Dock and Finder defaults (can be tweaked later)
  system.defaults = {
    dock.autohide = true;
    dock.autohide-delay = 0.15;
    dock.show-recents = false;
    finder.FXPreferredViewStyle = "clmv";
  };

  # Reuse system.stateVersion from common.nix unless explicitly overridden
  system.stateVersion = lib.mkDefault "23.11";
}