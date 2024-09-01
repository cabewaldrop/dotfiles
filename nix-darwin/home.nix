{ config, pkgs, ... }:

{
  home.username = "cabewaldrop";
  home.homeDirectory = "/Users/cabewaldrop";
  home.stateVersion = "23.05"; # Please read the comment before changing.

# Makes sense for user specific applications that shouldn't be available system-wide
  home.packages = [
  ];

  home.file = {
    ".zshrc".source = /Users/cabewaldrop/dotfiles/zshrc/.zshrc;
    ".config/nvim".source = ~/dotfiles/nvim;
    ".config/starship".source = ~/dotfiles/starship;
    ".config/wezterm".source = ~/dotfiles/wezterm;
    ".config/zellij".source = ~/dotfiles/zellij;
    ".config/nix".source = ~/dotfiles/nix;
    ".config/nix-darwin".source = ~/dotfiles/nix-darwin;
  };

  home.sessionVariables = {
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin"
  ];
  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    initExtra = ''
      # Add any additional configurations here
      export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';
  };
}
