{
  config,
  lib,
  pkgs,
  appFont,
  ...
}: let
  colors = import ../colors.nix;
  dmenuArgs = "-i -fn ${lib.escape [" "] "${appFont} 14"}";
  menu = "${pkgs.fuzzel}/bin/fuzzel";
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
    fuzzel
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
        riverctl map normal $mod D spawn "${menu}"
        # TODO rewrite passmenu to use an arbitrary launcher
        riverctl map normal $mod P spawn "${pkgs.pass}/bin/passmenu ${dmenuArgs}"
        riverctl map normal $mod Q spawn "${pkgs.qbpm}/bin/qbpm choose --menu=\"${menu} --dmenu\""
        riverctl default-layout rivertile
        sh -c "systemctl --user import-environment; systemctl --user start river-session.target; systemctl --user restart graphical-session.target"
        riverctl spawn yambar
        exec rivertile -view-padding 6 -outer-padding 6
      ''
    ];
    executable = true;
  };

  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    font=${appFont}:size=14
    terminal=${pkgs.foot}/bin/footclient
  '';
}
