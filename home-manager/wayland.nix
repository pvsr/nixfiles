{
  flake.modules.homeManager.desktop =
    { config, pkgs, ... }:
    let
      colors = import ./_colors.nix;
    in
    {
      imports = [ ];

      home.packages = with pkgs; [
        xwayland
        imv
        xdg-utils
        wl-clipboard
        libnotify
        dmenu-wayland
        swaylock
        pamixer
        playerctl
        pulsemixer
        rofimoji
      ];

      home.pointerCursor = {
        package = pkgs.vanilla-dmz;
        name = "Vanilla-DMZ";
        gtk.enable = true;
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
        mako = with colors; {
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
