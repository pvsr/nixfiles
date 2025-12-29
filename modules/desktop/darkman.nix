{ lib, ... }:
let
  modeToggleService = lib.mergeAttrs {
    wantedBy = [ "set-ui-mode.target" ];
    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = false;
  };
  activate = mode: ''
    systemctl --user set-environment UI_MODE=${mode}
    systemctl --user start set-ui-mode.target
  '';
in
{
  flake.modules.hjem.desktop =
    { pkgs, ... }:
    {
      packages = [ pkgs.darkman ];
      systemd.targets.set-ui-mode.unitConfig = {
        Description = "Switch to light/dark mode based on $UI_MODE";
        StopWhenUnneeded = true;
      };
      systemd.services.set-gtk-scheme = modeToggleService {
        description = "Set GTK UI scheme";
        script = ''
          ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-$UI_MODE'"
        '';
      };
      systemd.services.niri-screen-transition = modeToggleService {
        description = "Niri screen transition effect";
        script = ''
          niri msg action do-screen-transition -d ''${UI_TRANSITION_MS:-250}
        '';
      };

      xdg.config.files."darkman/config.yaml".text = ''
        lat: 42.4
        lng: -71.1
      '';

      xdg.data.files."dark-mode.d/systemd".source = pkgs.writeShellScript "systemd-dark" (
        activate "dark"
      );
      xdg.data.files."light-mode.d/systemd".source = pkgs.writeShellScript "systemd-light" (
        activate "light"
      );

      # https://github.com/feel-co/hjem/issues/76
      # xdg.config.files."systemd/user/darkman.service".source =
      #   "${pkgs.darkman}/share/systemd/user/darkman.service";
      systemd.services.darkman = {
        unitConfig = {
          Description = "Darkman system service";
          Documentation = "man:darkman(1)";
          PartOf = [ "graphical-session.target" ];
          BindsTo = [ "graphical-session.target" ];
        };

        serviceConfig = {
          Type = "dbus";
          BusName = "nl.whynothugo.darkman";
          ExecStart = "${lib.getExe pkgs.darkman} run";
          Restart = "on-failure";
          TimeoutStopSec = 15;
          Slice = "background.slice";
        };

        wantedBy = lib.mkDefault [ "graphical-session.target" ];
      };
    };
}
