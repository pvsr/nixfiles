{ config, ... }:
let
  cursor =
    { pkgs, ... }:
    {
      packages = [ pkgs.vanilla-dmz ];
      environment.sessionVariables.XCURSOR_THEME = "Vanilla-DMZ";
      environment.sessionVariables.XCURSOR_SIZE = 32;
    };
  services =
    { pkgs, ... }:
    {
      packages = with pkgs; [
        mako
        clipman
      ];

      xdg.config.files."mako/config".text = with config.local.colors; ''
        font=${config.local.appFont} 14
        background-color=${brightBlue}
        border-color=${blue}
        text-color=${xgray1}
      '';

      xdg.data.files."dbus-1/services/fr.emersion.mako.service".source =
        "${pkgs.mako}/share/dbus-1/services/fr.emersion.mako.service";

      # from home-manager
      systemd.services.clipman = {
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        unitConfig = {
          Description = "Clipboard management daemon";
          ConditionEnvironment = "WAYLAND_DISPLAY";
        };
        serviceConfig = {
          ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste -t text --watch ${pkgs.clipman}/bin/clipman store";
          ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
          Restart = "on-failure";
          KillMode = "mixed";
        };
      };
    };
in
{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        fuzzel
        imv
        xdg-utils
        wl-clipboard
        libnotify
        dmenu-wayland
        swaylock
        pulsemixer
        rofimoji
      ];

      services.playerctld.enable = true;
    };

  flake.modules.hjem.desktop =
    { pkgs, ... }:
    {
      imports = [
        cursor
        services
      ];

      mpv.defaultProfile = "wayland";

      xdg.config.files."fuzzel/fuzzel.ini".text = ''
        [main]
        font="${config.local.appFont}:size=14"
        terminal="${pkgs.ghostty}/bin/ghostty -e"
      '';
    };
}
