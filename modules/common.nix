{ config, pkgs, lib, ... }:

{
  ###########################################################################
  # Common configuration for all hosts (macOS & NixOS)
  ###########################################################################

  # Allow installation of unfree software for all machines
  nixpkgs.config.allowUnfree = true;

  # Enable Nix flakes and the new CLI universally
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Shared packages installed system-wide
  environment.systemPackages = with pkgs; [
    git
    vim
    lsd
    bat
    starship
    wget
    cargo
    ffmpeg
    brave
    kitty
    kitty-themes
    vscode
    pfetch
  ];

  # Kitty themes are provided declaratively via the package `pkgs.kitty-themes`.

  # Shared Nerd Fonts using new namespace
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  # Default system.stateVersion to prevent rebuild warnings
  # (Each host can override if necessary.)
  # Expose kitty-themes under /run/current-system/sw so Kitty can reference a
  # stable path that never contains a changing store hash.
  environment.pathsToLink = [ "/share/kitty-themes" ];

  system.stateVersion = lib.mkDefault 6;
}