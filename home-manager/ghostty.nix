{ config, ... }:
{
  flake.modules.homeManager.desktop =
    { lib, pkgs, ... }:
    {
      programs.ghostty = {
        enable = true;
        enableFishIntegration = false;
        settings = {
          theme = "srcery";
          command = "fish";
          font-family = config.local.appFont;
          font-size = lib.mkDefault 15;
          # TODO only on niri
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
          keybind = [
            "ctrl+[=text:\\x1b"
            "alt+f4=unbind"
            "ctrl+shift+q=unbind"
            "ctrl+enter=unbind"
            "alt+1=unbind"
            "alt+2=unbind"
            "alt+3=unbind"
            "alt+4=unbind"
            "alt+5=unbind"
            "alt+6=unbind"
            "alt+7=unbind"
            "alt+8=unbind"
            "alt+9=unbind"
            "alt+0=unbind"
          ];
        };
      };
    };
}
