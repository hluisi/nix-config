{ config, pkgs, lib, ... }:

{
  ###########################################################################
  # Homebrew integration (macOS only)
  #
  # This module expects to be imported only on Darwin systems alongside the
  # nix-homebrew module provided by the nix-homebrew flake input.
  ###########################################################################

  homebrew = {
    enable = true;

    # Formulae and casks installed via Homebrew
    brews = [
      "mas"
      "portaudio"
    ];
    casks = [
      "ghostty"
    ];

    # Mac App Store applications via `mas`
    masApps = {
      "Clean My Mac" = 1339170533;
    };

    # Homebrew activation options
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };

  # Ensure the Homebrew prefix comes after Nix binaries (handled in .zshrc)
  # Additional Darwin-only tweaks could be added here
}