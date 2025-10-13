{ config, ... }:
{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        imv
        xdg-utils
        wl-clipboard
        libnotify
        dmenu-wayland
        swaylock
        playerctl
        pulsemixer
        rofimoji
      ];

      home.pointerCursor = {
        package = pkgs.vanilla-dmz;
        name = "Vanilla-DMZ";
        gtk.enable = true;
        dotIcons.enable = false;
      };

      programs = {
        mpv.profiles.standard.gpu-context = "wayland";
        fuzzel.enable = true;
        fuzzel.settings = {
          main = {
            font = "${config.local.appFont}:size=14";
            terminal = "${pkgs.ghostty}/bin/ghostty -e";
          };
          # colors = {};
        };
      };

      services = {
        mako = with config.local.colors; {
          enable = true;
          settings = {
            font = "${config.local.appFont} 14";
            background-color = brightBlue;
            border-color = blue;
            text-color = xgray1;
          };
        };

        clipman.enable = true;
        clipman.systemdTarget = "graphical-session.target";

        playerctld.enable = true;
      };
    };
}
