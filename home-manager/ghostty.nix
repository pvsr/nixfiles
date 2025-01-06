{
  pkgs,
  lib,
  appFont,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;
  colors = import ./colors.nix;
in
{
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "srcery";
      command = "fish";
      font-family = appFont;
      font-size = lib.mkDefault 15;
      scrollback-limit = 0;
      window-decoration = !pkgs.stdenv.isLinux;
      cursor-style-blink = false;
      shell-integration-features = "no-cursor";
      mouse-hide-while-typing = true;
      window-padding-x = 0;
      window-padding-y = 0;
      window-padding-balance = true;
      window-padding-color = "extend";
      window-step-resize = true;
      gtk-single-instance = true;
      confirm-close-surface = false;
      quit-after-last-window-closed = true;
    };
  };
}
