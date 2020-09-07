{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    tmux
  ];

  programs.tmux = {
    enable = true;
    shortcut = "a";
    keyMode = "vi";
    terminal = "screen-256color";
    newSession = false;
    clock24 = true;
    plugins = with pkgs; [
      tmuxPlugins.resurrect
      tmuxPlugins.pain-control
      tmuxPlugins.prefix-highlight
      tmuxPlugins.sensible
      tmuxPlugins.yank
    ];
    extraConfig = ''
      set -g mouse on
      set -ga terminal-overrides ",xterm-256color:Tc"
      set-option -g default-shell "${pkgs.fish}/bin/fish"
      run -b ~/.local/share/tmux/themes/srcery-tmux/srcery.tmux
      bind C-a send-prefix
      bind a last-window
    '';
  };

  home.file.".local/share/tmux/themes/srcery-tmux".source = pkgs.fetchFromGitHub {
    owner = "srcery-colors";
    repo = "srcery-tmux";
    rev = "79ffd85e72ed94676222512186e3cfcbf41af5b1";
    sha256 = "1s2asnp3yvy5bgrgscwaf7g6hm94a7pdbm6aq3gcl7fgk8czqc2g";
  };

}
