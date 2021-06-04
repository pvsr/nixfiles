{ pkgs, ... }:
{
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.enable = true;

  boot.tmpOnTmpfs = true;

  security.sudo.wheelNeedsPassword = false;

  fonts = {
    fonts = with pkgs; [
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      libertinus
      iosevka
      sarasa-gothic
      font-awesome
      fantasque-sans-mono
    ];
    fontconfig.defaultFonts = {
      monospace = [ "DejaVu Sans Mono" ];
      sansSerif = [ "DejaVu Sans" ];
    };
  };

  environment = {
    sessionVariables = {
      #QT_QPA_PLATFORMTHEME = "gtk2";
    };

    systemPackages = with pkgs; [
      #cursor
      feh
      pulsemixer
    ];
  };
}
