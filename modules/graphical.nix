{
  config,
  lib,
  pkgs,
  ...
}:
let
  enable = config.local.niri.enable || config.local.gnome.enable;
in
{
  config = lib.mkIf enable {
    hardware.graphics.enable = true;
    hardware.bluetooth.enable = true;
    services.speechd.enable = false;

    services.openssh.settings.AcceptEnv = "TERMINFO COLORTERM";

    services.displayManager.ly.enable = true;

    boot.tmp = {
      useTmpfs = true;
      tmpfsSize = "75%";
    };

    xdg.icons.enable = true;

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        dejavu_fonts
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        libertinus
        sarasa-gothic
        font-awesome
        fantasque-sans-mono
      ];
      fontconfig.defaultFonts = {
        monospace = [ "DejaVu Sans Mono" ];
        sansSerif = [ "DejaVu Sans" ];
      };
    };

    environment.systemPackages = with pkgs; [
      man-pages
      bluetuith
    ];

    documentation.dev.enable = true;
    nix.extraOptions = "keep-outputs = true";

    # srcery
    console.colors = [
      "1c1b19"
      "ef2f27"
      "519f50"
      "fbb829"
      "2c78bf"
      "e02c6d"
      "0aaeb3"
      "baa67f"
      "918175"
      "f75341"
      "98bc37"
      "fed06e"
      "68a8e4"
      "ff5c8f"
      "2be4d0"
      "fce8c3"
    ];
  };
}
