{ pkgs, appFont, ... }:
let
  colors = import ./colors.nix;
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
        font = "${appFont}:size=14";
        terminal = "${pkgs.ghostty}/bin/ghostty -e";
      };
      # colors = {};
    };
  };

  services = {
    mako = with colors; {
      enable = true;
      font = "${appFont} 14";
      backgroundColor = brightBlue;
      borderColor = blue;
      textColor = xgray1;
    };

    clipman.enable = true;
    clipman.systemdTarget = "graphical-session.target";

    playerctld.enable = true;
  };
}
