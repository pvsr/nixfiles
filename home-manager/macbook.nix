{ pkgs, ... }:
{
  imports = [ ./common.nix ];

  home = {
    username = "price";
    homeDirectory = "/Users/price";
  };

  home.packages = with pkgs; [
    uutils-coreutils-noprefix
    timg
    sarasa-gothic
    fantasque-sans-mono
  ];

  # TODO 23.11: readd firefox module
  # programs.firefox.package = null;

  programs.fish = {
    enable = true;
    shellAbbrs = {
      suod = "sudo";
    };
    shellAliases.rmi = "hub --git-dir=(realpath ~/dev/report-management-issues/.git) issue";
  };

  programs.bash.enable = false;
  programs.git.userEmail = "price@hubspot.com";
  programs.jujutsu.settings.user.email = "price@hubspot.com";
  programs.tmux.terminal = "screen-256color";
}
