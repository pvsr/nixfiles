{
  config,
  lib,
  pkgs,
  appFont,
  ...
}: let
  colors = import ../colors.nix;
  dmenuArgs = "-i -fn ${lib.escape [" "] "${appFont} 14"}";
in {
  imports = [
    ../wayland.nix
  ];

  xsession.windowManager.i3.enable = true;

  home.packages = with pkgs; [
    niri
  ];

  # xdg.configFile."niri/config.kdl" = {
  #   text = builtins.readFile /home/peter/.config/niri/config.kdl;
  # };
}
