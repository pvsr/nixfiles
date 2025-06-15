{ pkgs, ... }:
{
  imports = [
    ./common.nix
    ./firefox.nix
  ];

  home = {
    username = "price";
    homeDirectory = "/Users/price";
  };

  home.packages = with pkgs; [
    uutils-coreutils-noprefix
    sarasa-gothic
    fantasque-sans-mono
  ];

  programs.firefox.package = null;

  programs.git.userEmail = "price@hubspot.com";
  programs.jujutsu.settings.user.email = "price@hubspot.com";
  programs.tmux.terminal = "screen-256color";
}
