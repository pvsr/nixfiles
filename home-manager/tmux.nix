{ pkgs, lib, ... }:
{
  programs.tmux = {
    enable = true;
    shortcut = "a";
    keyMode = "vi";
    terminal = lib.mkDefault "tmux-256color";
    newSession = true;
    clock24 = true;
    escapeTime = 0;
    plugins = with pkgs; [
      tmuxPlugins.pain-control
      tmuxPlugins.yank
      tmuxPlugins.srcery
    ];
    extraConfig = ''
      set -g mouse on
      set -ga update-environment "WAYLAND_DISPLAY NIRI_SOCKET COLORTERM"
      set-option -g default-shell "${pkgs.fish}/bin/fish"
      set-option -g renumber-windows on

      bind C-a send-prefix
      bind a last-window
    '';
  };
}
