{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./common.nix
    ./alacritty.nix
    #./tasks.nix
  ];

  home.packages = with pkgs; [
    sarasa-gothic
    fantasque-sans-mono
  ];

  #packageOverrides = pkgs: rec {
  #  maven = pkgs.maven.override {
  #    jre = pkgs.jdk11;
  #  };
  #};

  #programs.java = {
  #  enable = true;
  #  package = pkgs.jdk1;
  #};

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
