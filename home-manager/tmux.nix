{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shortcut = "a";
    keyMode = "vi";
    terminal = "tmux-256color";
    newSession = false;
    clock24 = true;
    plugins = with pkgs; [
      tmuxPlugins.resurrect
      tmuxPlugins.pain-control
      tmuxPlugins.prefix-highlight
      tmuxPlugins.sensible
      tmuxPlugins.yank
      tmuxPlugins.srcery
    ];
    extraConfig = ''
      set -g mouse on
      set-option -g default-shell "${pkgs.fish}/bin/fish"
      bind C-a send-prefix
      bind a last-window
    '';
  };

  home.shellAliases.tmux = "command tmux attach || command tmux";
}
