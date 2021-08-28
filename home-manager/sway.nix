{ config, lib, pkgs, appFont, ... }:
let
  cfg = config.wayland.windowManager.sway;
  modifier = cfg.config.modifier;

  font = appFont;
  fonts = {
    names = [ font ];
    size = 14.0;
  };
  colors = import ./colors.nix;
  exitMode = "(l)ock, (e)xit, (s)uspend, (r)eboot, (S)hutdown";
in
{
  imports = [
    ./alacritty.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard
    pamixer
    playerctl
    dmenu-wayland
    clipman
  ];

  programs.mpv.profiles.standard.gpu-context = "wayland";

  wayland.windowManager.sway.enable = true;
  wayland.windowManager.sway.systemdIntegration = true;
  wayland.windowManager.sway.wrapperFeatures.gtk = true;

  wayland.windowManager.sway.config = with colors; {
    modifier = "Mod4";
    terminal = lib.mkDefault "SHELL=${pkgs.fish}/bin/fish ${pkgs.alacritty}/bin/alacritty";
    inherit fonts;


    menu = ''
      ${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop \
        --dmenu='dmenu-wl -i -fn "${font} 13"' \
        | ${pkgs.findutils}/bin/xargs swaymsg exec --
    '';

    workspaceAutoBackAndForth = true;

    input."*" = { xkb_variant = "altgr-intl"; xkb_options = "ctrl:nocaps"; };
    output."*" = { bg = "~/background fit"; };

    keybindings = lib.mkOptionDefault {
      "${modifier}+z" = "workspace back_and_forth";
      "${modifier}+Shift+z" = "move container to workspace back_and_forth";
      "${modifier}+q" = "mode '${exitMode}'";
      "${modifier}+p" = "exec ${pkgs.pass}/bin/passmenu -i -fn '${font} 13'";

      Print = "exec ${pkgs.grim}/bin/grim $(xdg-user-dir PICTURES)/screenshots/$(date +'%Y-%m-%d-%H:%M:%S.png')";
      "Shift+Print" = "exec ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - $(xdg-user-dir PICTURES)/screenshots/$(date +'%Y-%m-%d-%H:%M:%S.png')";
    };

    startup = [
      { command = "${pkgs.mako}/bin/mako"; }
      { command = "mkfifo $SWAYSOCK.wob && tail -f $SWAYSOCK.wob | ${pkgs.wob}/bin/wob"; }
      { command = "wl-paste -t text --watch clipman store"; }
      {
        command = lib.concatStringsSep " " [
          "${pkgs.swayidle}/bin/swayidle"
          "timeout 600 'swaymsg \"output * dpms off\"'"
          "resume 'swaymsg \"output * dpms on\"'"
        ];
      }
    ];

    modes."${exitMode}" = {
      l = "exec swaylock -c '${black}', mode 'default'";
      e = "exit";
      s = "exec swaylock -c '${black}' -f && systemctl suspend, mode 'default'";
      r = "exec systemctl reboot -i, mode 'default'";
      "Shift+s" = "exec systemctl poweroff -i, mode 'default'";

      Return = "mode 'default'";
      Escape = "mode 'default'";
      "Control+bracketleft" = "mode 'default'";
    };

    modes.resize = {
      h = "resize shrink width 5 px or 5 ppt";
      j = "resize grow height 5 px or 5 ppt";
      k = "resize shrink height 5 px or 5 ppt";
      l = "resize grow width 5 px or 5 ppt";

      left = "resize shrink width 5 px or 5 ppt";
      down = "resize grow height 5 px or 5 ppt";
      up = "resize shrink height 5 px or 5 ppt";
      right = "resize grow width 5 px or 5 ppt";

      Return = "mode 'default'";
      Escape = "mode 'default'";
      "Control+bracketleft" = "mode 'default'";
    };

    floating.criteria = [
      { title = "Steam - Update News"; }
      { class = "(?i)feh"; }
      { instance = "qb-nvim"; }
    ];
    window.hideEdgeBorders = "smart";
    window.commands = [
      { command = "border pixel 0"; criteria = { class = "Steam"; }; }
      { command = "border pixel 0"; criteria = { instance = "steam.exe"; }; }
    ];

    # wrapperFeatures.gtk = true;

    colors = {
      focused = {
        border = xgray2;
        background = xgray2;
        text = white;
        indicator = black;
        childBorder = xgray2;
      };
      focusedInactive = {
        border = xgray1;
        background = xgray1;
        text = white;
        indicator = black;
        childBorder = xgray1;
      };
      unfocused = {
        border = black;
        background = black;
        text = white;
        indicator = black;
        childBorder = black;
      };
      urgent = {
        border = black;
        background = black;
        text = white;
        indicator = black;
        childBorder = black;
      };
    };
    bars = [
      {
        position = "top";
        # TODO add contrib to store
        statusCommand = "SCRIPT_DIR=~/.config/i3blocks/i3blocks-contrib ${pkgs.i3blocks}/bin/i3blocks";
        inherit fonts;
        colors = {
          background = black;
          statusline = white;
          separator = red;
          focusedWorkspace = {
            border = xgray2;
            background = xgray2;
            text = white;
          };
          activeWorkspace = {
            border = xgray1;
            background = xgray1;
            text = white;
          };
          inactiveWorkspace = {
            border = black;
            background = black;
            text = xgray5;
          };
          urgentWorkspace = {
            border = black;
            background = black;
            text = yellow;
          };
          bindingMode = {
            border = xgray2;
            background = xgray2;
            text = white;
          };
        };
      }
    ];
  };

  # TODO
  wayland.windowManager.sway.extraConfig = ''
    bindsym --locked XF86AudioPlay exec playerctl -a status | grep Playing > /dev/null && playerctl -a pause || playerctl play
    bindsym --locked XF86AudioPrev exec playerctl previous
    bindsym --locked XF86AudioNext exec playerctl next
    bindsym --locked XF86AudioStop exec playerctl stop
    bindsym --locked XF86AudioMute exec pamixer --toggle-mute && pkill -RTMIN+10 i3blocks && (pamixer --get-mute && echo 0 > $SWAYSOCK.wob) || pamixer --get-volume > $SWAYSOCK.wob
    bindsym --locked XF86AudioRaiseVolume exec pamixer -ui 5 && pkill -RTMIN+10 i3blocks && pamixer --get-volume > $SWAYSOCK.wob
    bindsym --locked XF86AudioLowerVolume exec pamixer -ud 5 && pkill -RTMIN+10 i3blocks && pamixer --get-volume > $SWAYSOCK.wob
  '';
  wayland.windowManager.sway.extraSessionCommands = ''
    export QT_QPA_PLATFORM=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export _JAVA_AWT_WM_NONREPARENTING=1
  '';

  programs.mako = with colors; {
    enable = true;
    font = "${font} 14";
    backgroundColor = brightBlue;
    borderColor = blue;
    textColor = xgray1;
  };
}
