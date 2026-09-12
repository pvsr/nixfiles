{ lib, ... }:
let
  services =
    { pkgs, ... }:
    {
      packages = with pkgs; [
        clipman
      ];

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
        wiremix
        rofimoji
      ];

      services.playerctld.enable = true;
    };

  flake.modules.hjem.core.options.fuzzel.extraConfig = lib.mkOption {
    type = lib.types.lines;
    default = "";
  };

  flake.modules.hjem.desktop =
    { config, pkgs, ... }:
    {
      imports = [ services ];

      mpv.defaultProfile = "wayland";

      xdg.config.files."fuzzel/fuzzel.ini".text = ''
        [main]
        terminal="${pkgs.ghostty}/bin/ghostty -e"
        ${config.fuzzel.extraConfig}
      '';
    };
}
