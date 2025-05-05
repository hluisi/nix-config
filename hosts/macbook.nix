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
    brave
    kitty
    mkalias
    obsidian
    pfetch
    vscode

    # Optional zsh plugins
    # zsh-autosuggestions
    # zsh-history
    # zsh-syntax-highlighting
  ];

  # Example Dock and Finder defaults (can be tweaked later)
  system.defaults = {
    dock.autohide = true;
    dock.autohide-delay = 0.15;
    dock.show-recents = false;
    finder.FXPreferredViewStyle = "clmv";
  };
  }