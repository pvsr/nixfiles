{ config, lib, ... }:

{
  # srcery
  options.local.colors = lib.mkOption {
    readOnly = true;
    default = {
      black = "#1C1B19";
      brightBlack = "#918175";

      red = "#EF2F27";
      brightRed = "#F75341";

      green = "#519F50";
      brightGreen = "#98BC37";

      yellow = "#FBB829";
      brightYellow = "#FED06E";

      blue = "#2C78BF";
      brightBlue = "#68A8E4";

      magenta = "#E02C6D";
      brightMagenta = "#FF5C8F";

      cyan = "#0AAEB3";
      brightCyan = "#2BE4D0";

      white = "#BAA67F";
      brightWhite = "#FCE8C3";

      orange = "#FF5F00";
      brightOrange = "#FF8700";

      xgray1 = "#262626";
      xgray2 = "#303030";
      xgray3 = "#3A3A3A";
      xgray4 = "#444444";
      xgray5 = "#4E4E4E";
      xgray6 = "#585858";

      hardBlack = "#121212";
    };
  };

  config.flake.modules.nixOnDroid.base.terminal.colors = with config.local.colors; {
    foreground = brightWhite;
    background = black;
    cursor = yellow;
    # Black
    color0 = black;
    color8 = brightBlack;
    # Red
    color1 = red;
    color9 = brightRed;
    # Green
    color2 = green;
    color10 = brightGreen;
    # Yellow
    color3 = yellow;
    color11 = brightYellow;
    # Blue
    color4 = blue;
    color12 = brightBlue;
    # Magenta
    color5 = magenta;
    color13 = brightMagenta;
    # Cyan
    color6 = cyan;
    color14 = brightCyan;
    # White
    color7 = white;
    color15 = brightWhite;
  };

}
