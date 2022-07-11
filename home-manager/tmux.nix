{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.tmux = {
    enable = true;
    shortcut = "a";
    keyMode = "vi";
    terminal = lib.mkDefault "tmux-256color";
    newSession = true;
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
      set-option -g set-titles on
      bind C-a send-prefix
      bind a last-window
    '';
  };
}
