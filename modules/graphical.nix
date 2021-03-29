{ pkgs, ... }:
{
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.enable = true;

  boot.tmpOnTmpfs = true;

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
