{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./common.nix
  ];

  home = {
    username = "price";
    homeDirectory = "/Users/price";
  };

  home.packages = with pkgs; [
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
  programs.alacritty.settings.font.size = 16.0;
  programs.tmux.terminal = "screen-256color";
}
