{ lib, ... }:
let
  modeToggleService = lib.mergeAttrs {
    Install.WantedBy = [ "set-ui-mode.target" ];
    Service.Type = "oneshot";
    Service.RemainAfterExit = false;
  };
  activate = mode: ''
    systemctl --user set-environment UI_MODE=${mode}
    systemctl --user start set-ui-mode.target
  '';
in
{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      systemd.user.targets.set-ui-mode.Unit = {
        Description = "Switch to light/dark mode based on $UI_MODE";
        StopWhenUnneeded = true;
      };
      systemd.user.services.set-gtk-scheme = modeToggleService {
        Unit.Description = "Set GTK UI scheme";
        Service.ExecStart = pkgs.writeShellScript "set-gtk-scheme" ''
          ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-$UI_MODE'"
        '';
      };
      systemd.user.services.niri-screen-transition = modeToggleService {
        Unit.Description = "Niri screen transition effect";
        Service.ExecStart = pkgs.writeShellScript "niri-screen" ''
          niri msg action do-screen-transition -d ''${UI_TRANSITION_MS:-250}
        '';
      };

      services.darkman = {
        enable = true;
        settings = {
          lat = 42.4;
          lng = -71.1;
        };
        darkModeScripts.target = activate "dark";
        lightModeScripts.target = activate "light";
      };
    };
}
