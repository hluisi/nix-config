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
    starship
    wget
  ];

  # Minimal shared fonts example (optional override per-host)
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

  # Default system.stateVersion to prevent rebuild warnings
  # (Each host can override if necessary.)
  system.stateVersion = lib.mkDefault "23.11";
}