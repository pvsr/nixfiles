{ config, lib, ... }:
{
  flake.modules.nixos.desktop = {
    services.displayManager.ly.enable = true;
    # defaults to true when display manager is enabled (graphical-desktop.nix)
    services.speechd.enable = false;

    services.openssh.settings.AcceptEnv = [
      "TERMINFO"
      "COLORTERM"
    ];

    xdg.icons.enable = true;
    xdg.mime.enable = true;
    xdg.sounds.enable = true;
    xdg.autostart.enable = lib.mkForce false;
  };
}
