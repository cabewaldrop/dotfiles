{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager}:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          pkgs.vim
          pkgs.glow
          pkgs.topgrade
          pkgs.bruno
          pkgs.ripgrep
          pkgs.eza
          pkgs.neovim
          pkgs.raycast
          pkgs.obsidian
          pkgs.git
          pkgs.zellij
          pkgs.zoxide
          pkgs.pnpm
          pkgs.asdf-vm
	        pkgs.zsh
          pkgs.starship
          pkgs.just
          pkgs.jq
          pkgs.lua
          pkgs.luarocks
          pkgs.atuin
          pkgs.bat
          pkgs.lazygit
          pkgs.terraform
          pkgs.ollama
          pkgs.direnv
        ];

      services.nix-daemon.enable = true;
      nix.settings.experimental-features = "nix-command flakes";
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 4;
      nixpkgs.hostPlatform = "aarch64-darwin";

      users.users.cabewaldrop.home = "/Users/cabewaldrop";
      home-manager.backupFileExtension = "backup";
      nix.configureBuildUsers = true;
      nix.useDaemon = true;

      system.defaults = {
        dock.autohide = true;
        dock.mru-spaces = false;
        finder.AppleShowAllExtensions = true;
      };

      programs.zsh = {
        enable = true;
        enableCompletion = true;
      };
      
      # Homebrew needs to be installed on its own!
      homebrew.enable = true;
      homebrew.casks = [
        "nikitabobko/tap/aerospace"
        "orbstack"
      ];
      homebrew.brews = [
	      "imagemagick"
      ];
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Cabes-MacBook-Pro
    darwinConfigurations."Cabes-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
      configuration
      home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.cabewaldrop = import ./home.nix;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Cabes-MacBook-Pro".pkgs;
  };
}
