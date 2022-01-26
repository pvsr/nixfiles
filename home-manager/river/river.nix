{ config, lib, pkgs, appFont, ... }:
let
  colors = import ../colors.nix;
in
{
  imports = [
    ../alacritty.nix
    ../foot.nix
  ];

  home.packages = with pkgs; [
    river
    wl-clipboard
    pamixer
    playerctl
    dmenu-wayland
    clipman
  ];

  programs.mpv.profiles.standard.gpu-context = "wayland";

  programs.mako = with colors; {
    enable = true;
    font = "${appFont} 14";
    backgroundColor = brightBlue;
    borderColor = blue;
    textColor = xgray1;
  };

  systemd.user.targets.river-session = {
    Unit = {
      Description = "river compositor session";
      # Documentation = [ "man" ];
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
    };
  };

  xdg.configFile."river/init" = {
    text = lib.concatStringsSep "\n" [
      "#!/bin/sh"
      "mod='Mod4'"
      # "riverctl background-color ${}"
      # "riverctl border-color-focused ${}"
      # "riverctl border-color-unfocused ${}"
      (builtins.readFile ./init)
      ''
        riverctl map normal $mod D spawn 'exec $(${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop --dmenu="dmenu-wl -i -fn \"${appFont} 13\"")'
        riverctl map normal $mod P spawn '${pkgs.pass}/bin/passmenu -i -fn "${appFont} 13"'
        riverctl default-layout rivertile
        sh -c "systemctl --user import-environment; systemctl --user start river-session.target"
        exec rivertile -view-padding 6 -outer-padding 6
      ''
    ];
    executable = true;
  };
}
