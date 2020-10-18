{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    ranger
    ripgrep
    killall
    file
    diceware
    #tmux
    #jetbrains.idea-community
    #maven
    #jdk11
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

  programs.tmux = {
    enable = false;
    shortcut = "a";
    keyMode = "vi";
    terminal = "screen-256color";
    newSession = true;
    clock24 = true;
    extraConfig = ''
      set -ga terminal-overrides ",xterm-termite:Tc"

      set-option -g default-command "reattach-to-user-namespace -l ${pkgs.fish}/bin/fish"
      set-option -g default-shell "${pkgs.fish}/bin/fish"
    '';
    plugins = with pkgs; [
      tmuxPlugins.resurrect
      tmuxPlugins.gruvbox
      tmuxPlugins.pain-control
      tmuxPlugins.prefix-highlight
      tmuxPlugins.sensible
    ];
  };

  programs.fish = {
    functions = {
      mysql = builtins.readFile ~/dev/personal/scripts/mysql.fish;
    };
    shellAliases = {
      rmi = "hub --git-dir=(realpath ~/dev/report-management-issues/.git) issue";
    };
  };

  programs.git = {
    userEmail = "peter@peterrice.xyz";
  };

  #services.fontconfig.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.03";
}
