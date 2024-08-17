{ lib, appFont, ... }:
let
  colors = import ./colors.nix;
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      window.dynamic_title = true;
      draw_bold_text_with_bright_colors = true;
      font.normal.family = lib.mkDefault appFont;
      font.size = lib.mkDefault 14.0;
      colors = with colors; {
        primary.background = black;
        primary.foreground = brightWhite;

        normal = {
          inherit
            black
            red
            green
            yellow
            blue
            magenta
            cyan
            white
            ;
        };

        bright = {
          black = brightBlack;
          red = brightRed;
          green = brightGreen;
          yellow = brightYellow;
          blue = brightBlue;
          magenta = brightMagenta;
          cyan = brightCyan;
          white = brightWhite;
        };
      };
    };
  };

  programs.tmux.extraConfig = "set -ga terminal-overrides \",alacritty:Tc\"";
  programs.fish.interactiveShellInit = "set -g fish_vi_force_cursor";
}
