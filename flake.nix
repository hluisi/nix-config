{
  description = "Multi-machine Nix flake configuration (macOS & NixOS)";

  inputs = {
    # Core channels
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # macOS system manager
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Homebrew integration for macOS
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nix-darwin, nix-homebrew, homebrew-core, homebrew-cask, ... }:
  let
    # List of modules shared by all hosts
    commonModules = [
      ./modules/common.nix
    ];
  in
  {
    ############################################################################
    # macOS hosts (nix-darwin)
    ############################################################################
    darwinConfigurations = {
      macbook = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/macbook.nix
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = false; # For aarch64-darwin
              user = "hunter";
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
              };
            };
          }
        ] ++ commonModules;
      };

      work-mac = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/work-mac.nix
          nix-homebrew.darwinModules.nix-homebrew
        ] ++ commonModules;
      };
    };

    ############################################################################
    # Linux hosts (NixOS)
    ############################################################################
    nixosConfigurations = {
      nixos-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-desktop.nix
        ] ++ commonModules;
      };
    };
  };
}