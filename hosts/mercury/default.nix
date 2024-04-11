{ pkgs, ... }:
{

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      pkgs.home-manager
    ];

  fonts.fontDir.enable = true;
  fonts.fonts = [
    pkgs.ibm-plex
    pkgs.overpass
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  nix.settings.trusted-users = [ "root" "jacobpleiness" ];

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.fish.enable = true;

  programs.gnupg.agent.enable = true;

  homebrew = {
    enable = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "uninstall";
    brews = [
      "docker"
    ];

    casks = [
      "1password"
      "arq"
      "cleanshot"
      "discord"
      "focusrite-control-2"
      "google-chrome"
      "hammerspoon"
      "iterm2"
      "mixed-in-key"
      "monodraw"
      "notion-calendar"
      "obs"
      "obsidian"
      "opal-composer"
      "postico"
      "rectangle"
      "rekordbox"
      "visual-studio-code"
      "xld"
      "zed"
    ];
  };

  users.users.jacobpleiness = {
    home = "/Users/jacobpleiness";
    shell = pkgs.fish;
  };
}
