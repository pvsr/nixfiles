{
  pkgs,
  lib,
  appFont,
  ...
}: let
  colors = import ./colors.nix;
in {
  programs.foot = with (builtins.mapAttrs (n: v: lib.removePrefix "#" v) colors); {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "${appFont}:size=13";
        pad = "0x0";
      };
      colors = {
        foreground = brightWhite;
        background = black;
        regular0 = black;
        regular1 = red;
        regular2 = green;
        regular3 = yellow;
        regular4 = blue;
        regular5 = magenta;
        regular6 = cyan;
        regular7 = white;
        bright0 = brightBlack;
        bright1 = brightRed;
        bright2 = brightGreen;
        bright3 = brightYellow;
        bright4 = brightBlue;
        bright5 = brightMagenta;
        bright6 = brightCyan;
        bright7 = brightWhite;
      };
    };
  };
}
