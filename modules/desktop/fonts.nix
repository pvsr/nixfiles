{ lib, ... }:
let
  appFontPackage = "fantasque-sans-mono";
in
{
  options.local = {
    appFont = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = "Fantasque Sans Mono";
    };
  };

  config.flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      fonts.enableDefaultPackages = true;
      fonts.packages = with pkgs; [
        dejavu_fonts
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        libertinus
        sarasa-gothic
        font-awesome
        pkgs."${appFontPackage}"
      ];
      fonts.fontconfig.defaultFonts = {
        monospace = [ "DejaVu Sans Mono" ];
        sansSerif = [ "DejaVu Sans" ];
      };
    };

  config.flake.modules.hjem.macbook =
    { pkgs, ... }:
    {
      packages = [ pkgs."${appFontPackage}" ];
    };
}
