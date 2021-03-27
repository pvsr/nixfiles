{ pkgs, ... }:
let inherit (builtins) readFile;
in
{
  #imports = [ ../users/sway ];

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.pulseaudio.enable = true;

  boot = {
    tmpOnTmpfs = true;

    kernel.sysctl."kernel.sysrq" = 1;

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
