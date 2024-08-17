{
  lib,
  pkgs,
  appFont,
  ...
}:
{
  imports = [ ../wayland.nix ];

  xsession.windowManager.i3.enable = true;

  home.packages = with pkgs; [ niri ];

  # xdg.configFile."niri/config.kdl" = {
  #   text = builtins.readFile /home/peter/.config/niri/config.kdl;
  # };
}
