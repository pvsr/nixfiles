{
  config,
  lib,
  pkgs,
  appFont,
  ...
}: let
  colors = import ../colors.nix;
  dmenuArgs = "-i -fn ${lib.escape [" "] "${appFont} 14"}";
  dmenu = lib.escapeShellArg "${pkgs.dmenu-wayland}/bin/dmenu-wl ${dmenuArgs}";
in {
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
    yambar
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
      BindsTo = ["graphical-session.target"];
      Wants = ["graphical-session-pre.target"];
      After = ["graphical-session-pre.target"];
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
        riverctl map normal $mod D spawn ${lib.escapeShellArg "exec $(${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop --dmenu=${dmenu})"}
        riverctl map normal $mod P spawn "${pkgs.pass}/bin/passmenu ${dmenuArgs}"
        riverctl map normal $mod Q spawn "${pkgs.qbpm}/bin/qbpm choose --menu=${dmenu}"
        riverctl default-layout rivertile
        sh -c "systemctl --user import-environment; systemctl --user start river-session.target; systemctl --user restart graphical-session.target"
        riverctl spawn yambar
        exec rivertile -view-padding 6 -outer-padding 6
      ''
    ];
    executable = true;
  };
}
