{ config, ... }:
{
  flake.modules.nixos.desktop = {
    services.displayManager.ly.enable = true;
    # defaults to true when display manager is enabled (graphical-desktop.nix)
    services.speechd.enable = false;

    services.openssh.settings.AcceptEnv = "TERMINFO COLORTERM";

    console.colors =
      with config.local.colors;
      map (builtins.substring 1 (-1)) [
        black
        red
        green
        yellow
        blue
        magenta
        cyan
        white
        brightBlack
        brightRed
        brightGreen
        brightYellow
        brightBlue
        brightMagenta
        brightCyan
        brightWhite
      ];
  };
}
