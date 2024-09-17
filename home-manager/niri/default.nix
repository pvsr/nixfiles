{
  lib,
  pkgs,
  appFont,
  ...
}:
{
  imports = [ ../wayland.nix ];

  xsession.windowManager.i3.enable = true;
  home.packages = with pkgs; [
    xwayland-satellite-unstable
  ];
}
