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
    cargo
    ffmpeg
    brave
    kitty
    vscode
    pfetch
  ];

  # Ensure Kitty themes repository is cloned (or updated) every activation
  system.activationScripts.kittyThemes.text = ''
    THEME_DIR="$HOME/.config/kitty/themes"
    if [ ! -d "$THEME_DIR" ]; then
      git clone --depth 1 https://github.com/dexpota/kitty-themes.git "$THEME_DIR"
    else
      (cd "$THEME_DIR" && git pull)
    fi
  '';

  # Shared Nerd Fonts using new namespace
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  # Default system.stateVersion to prevent rebuild warnings
  # (Each host can override if necessary.)
  system.stateVersion = lib.mkDefault 6;
}