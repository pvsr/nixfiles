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
    ../foot.nix
  ];

  home.packages = with pkgs; [
    river
    wl-clipboard
    pamixer
    playerctl
    dmenu-wayland
    yambar
  ];

  programs = {
    mpv.profiles.standard.gpu-context = "wayland";
    fuzzel.enable = true;
    fuzzel.settings = {
      main = {
        font = "${appFont}:size=14";
        terminal = "${pkgs.foot}/bin/footclient";
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
    clipman.systemdTarget = "river-session.target";

    playerctld.enable = true;
  };

  systemd.user.targets.river-session = {
    Unit = {
      Description = "river compositor session";
      Documentation = ["man:systemd.special(7)"];
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
        riverctl map normal $mod D spawn fuzzel
        # TODO rewrite passmenu to use an arbitrary launcher
        riverctl map normal $mod P spawn 'passmenu ${dmenuArgs}'
        riverctl map normal $mod Q spawn 'qbpm choose --menu=fuzzel'
        riverctl map normal $mod X spawn 'umpv $(wl-paste)'
        riverctl default-layout rivertile
        sh -c "systemctl --user import-environment; systemctl --user start river-session.target; systemctl --user restart graphical-session.target"
        riverctl spawn ${pkgs.mako}/bin/mako
        riverctl spawn ${pkgs.yambar}/bin/yambar
        [[ -e ~/.background ]] && riverctl spawn '${pkgs.swaybg}/bin/swaybg -i ~/.background'
        exec rivertile -view-padding 6 -outer-padding 6
      ''
    ];
    executable = true;
  };
}
