{
  flake.modules.homeManager.core =
    { lib, pkgs, ... }:
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
          set-option -g history-limit 50000
          set-option -g focus-events on

          bind C-a send-prefix
          bind a last-window
          bind C-p previous-window
          bind C-n next-window
        '';
      };
    };
}
