{
  flake.modules.homeManager.desktop =
    { config, ... }:
    {
      programs.niri.settings.binds = with config.lib.niri.actions; {
        "Mod+Shift+Slash".action = show-hotkey-overlay;

        "Mod+T" = {
          hotkey-overlay.title = "Open a Terminal";
          action = spawn "ghostty";
        };
        "Mod+D" = {
          hotkey-overlay.title = "Run an Application";
          action = spawn "fuzzel";
        };
        "Mod+E" = {
          hotkey-overlay.title = "Pick an Emoji";
          action = spawn "rofimoji";
        };
        "Mod+Q" = {
          hotkey-overlay.title = "Run a qutebrowser Profile";
          action = spawn-sh "qbpm choose";
        };
        "Mod+X" = {
          hotkey-overlay.title = "Play Copied Link (umpv)";
          action = spawn-sh "umpv $(wl-paste)";
        };
        "Mod+Shift+X" = {
          hotkey-overlay.title = "Play Copied Link (mpv)";
          action = spawn-sh "mpv $(wl-paste)";
        };
        "Mod+Alt+L" = {
          hotkey-overlay.title = "Lock the Screen";
          action = spawn "swaylock";
        };

        "XF86AudioRaiseVolume".action = spawn-sh "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 0.05+";
        "XF86AudioLowerVolume".action = spawn-sh "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 0.05-";
        "Shift+XF86AudioRaiseVolume".action = spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+";
        "Shift+XF86AudioLowerVolume".action = spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
        "XF86AudioMute".action = spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute".action = spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        "XF86MonBrightnessUp".action = spawn-sh "light -A 5";
        "XF86MonBrightnessDown".action = spawn-sh "light -U 5";
        "XF86AudioPrev".action = spawn-sh "playerctl previous";
        "XF86AudioNext".action = spawn-sh "playerctl next";
        "XF86AudioMedia".action = spawn-sh "playerctl play-pause";
        "XF86AudioPlay".action = spawn-sh "playerctl play-pause";

        "Mod+O" = {
          action = toggle-overview;
          repeat = false;
        };
        "Mod+Shift+Q" = {
          action = close-window;
          repeat = false;
        };

        "Mod+Left".action = focus-column-left;
        "Mod+Down".action = focus-window-down;
        "Mod+Up".action = focus-window-up;
        "Mod+Right".action = focus-column-right;
        "Mod+H".action = focus-column-left;
        "Mod+J".action = focus-window-down;
        "Mod+K".action = focus-window-up;
        "Mod+L".action = focus-column-right;

        "Mod+Shift+Left".action = move-column-left;
        "Mod+Shift+Down".action = move-window-down;
        "Mod+Shift+Up".action = move-window-up;
        "Mod+Shift+Right".action = move-column-right;
        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+J".action = move-window-down;
        "Mod+Shift+K".action = move-window-up;
        "Mod+Shift+L".action = move-column-right;

        "Mod+Home".action = focus-column-first;
        "Mod+End".action = focus-column-last;
        "Mod+Shift+Home".action = move-column-to-first;
        "Mod+Shift+End".action = move-column-to-last;

        "Mod+Ctrl+Left".action = focus-monitor-left;
        "Mod+Ctrl+Down".action = focus-monitor-down;
        "Mod+Ctrl+Up".action = focus-monitor-up;
        "Mod+Ctrl+Right".action = focus-monitor-right;
        "Mod+Ctrl+H".action = focus-monitor-left;
        "Mod+Ctrl+J".action = focus-monitor-down;
        "Mod+Ctrl+K".action = focus-monitor-up;
        "Mod+Ctrl+L".action = focus-monitor-right;

        "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
        "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;

        "Mod+Page_Down".action = focus-workspace-down;
        "Mod+Page_Up".action = focus-workspace-up;
        "Mod+U".action = focus-workspace-down;
        "Mod+I".action = focus-workspace-up;
        "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down;
        "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;
        "Mod+Ctrl+U".action = move-column-to-workspace-down;
        "Mod+Ctrl+I".action = move-column-to-workspace-up;

        "Mod+Shift+Page_Down".action = move-workspace-down;
        "Mod+Shift+Page_Up".action = move-workspace-up;
        "Mod+Shift+U".action = move-workspace-down;
        "Mod+Shift+I".action = move-workspace-up;

        "Mod+Shift+WheelScrollDown" = {
          action = focus-workspace-down;
          cooldown-ms = 150;
        };
        "Mod+Shift+WheelScrollUp" = {
          action = focus-workspace-up;
          cooldown-ms = 150;
        };
        "Mod+Ctrl+Shift+WheelScrollDown" = {
          action = move-column-to-workspace-down;
          cooldown-ms = 150;
        };
        "Mod+Ctrl+Shift+WheelScrollUp" = {
          action = move-column-to-workspace-up;
          cooldown-ms = 150;
        };

        "Mod+WheelScrollRight".action = focus-column-right;
        "Mod+WheelScrollLeft".action = focus-column-left;
        "Mod+Ctrl+WheelScrollRight".action = move-column-right;
        "Mod+Ctrl+WheelScrollLeft".action = move-column-left;

        "Mod+WheelScrollDown".action = focus-column-right;
        "Mod+WheelScrollUp".action = focus-column-left;
        "Mod+Ctrl+WheelScrollDown".action = move-column-right;
        "Mod+Ctrl+WheelScrollUp".action = move-column-left;

        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+6".action = focus-workspace 6;
        "Mod+7".action = focus-workspace 7;
        "Mod+8".action = focus-workspace 8;
        "Mod+9".action = focus-workspace 9;
        "Mod+Ctrl+1".action.move-column-to-index = 1;
        "Mod+Ctrl+2".action.move-column-to-index = 2;
        "Mod+Ctrl+3".action.move-column-to-index = 3;
        "Mod+Ctrl+4".action.move-column-to-index = 4;
        "Mod+Ctrl+5".action.move-column-to-index = 5;
        "Mod+Ctrl+6".action.move-column-to-index = 6;
        "Mod+Ctrl+7".action.move-column-to-index = 7;
        "Mod+Ctrl+8".action.move-column-to-index = 8;
        "Mod+Ctrl+9".action.move-column-to-index = 9;

        "Mod+Tab".action = focus-workspace-previous;
        "Mod+Z".action = focus-workspace-previous;
        "Mod+Slash".action = focus-workspace-previous;

        "Mod+BracketLeft".action = consume-or-expel-window-left;
        "Mod+BracketRight".action = consume-or-expel-window-right;

        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;

        "Mod+R".action = switch-preset-column-width;
        "Mod+Shift+R".action = switch-preset-window-height;
        "Mod+Ctrl+R".action = reset-window-height;
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+Ctrl+Shift+F".action = toggle-windowed-fullscreen;
        "Mod+Ctrl+F".action = expand-column-to-available-width;

        "Mod+C".action = center-column;
        "Mod+Ctrl+C".action = center-visible-columns;

        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Equal".action = set-column-width "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Equal".action = set-window-height "+10%";

        "Mod+V".action = toggle-window-floating;
        "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;
        "Mod+W".action = toggle-column-tabbed-display;

        "Print".action.screenshot = [ ];
        "Ctrl+Print".action.screenshot-screen = [ ];
        "Alt+Print".action.screenshot-window = [ ];

        "Mod+Escape" = {
          action = toggle-keyboard-shortcuts-inhibit;
          allow-inhibiting = false;
        };

        "Mod+Shift+E".action = quit;
        "Ctrl+Alt+Delete".action = quit;
        "Mod+Shift+P".action = power-off-monitors;
      };
    };
}
