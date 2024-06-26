{
  description = "jacob's darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
    let
      configuration = { pkgs, ... }: {

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;
        system.defaults = {
          dock.autohide = true;
          dock.mru-spaces = false;
          dock.autohide-delay = 0.0;
          dock.autohide-time-modifier = 0.4;
          finder.AppleShowAllExtensions = true;
          NSGlobalDomain.InitialKeyRepeat = 12;
          NSGlobalDomain.KeyRepeat = 2;
          NSGlobalDomain.ApplePressAndHoldEnabled = false;
        };

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 4;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";

        nixpkgs.config.allowUnfree = true;
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations = {
        "mercury" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            configuration
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jacob = import ./hosts/mercury/home.nix;
            }
            ./hosts/mercury/default.nix
          ];
        };
        "eros" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            configuration
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jacob = import ./hosts/eros/home.nix;
            }
            ./hosts/eros/default.nix
          ];
        };
      };

      # Expose the package set, including overlays, for convenience.
      # darwinPackages = self.darwinConfigurations."mercury".pkgs;
    };
}
