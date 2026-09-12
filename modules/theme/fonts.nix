{ config, lib, ... }:
let
  inherit (config.local) appFont;
in
{
  options.local = {
    appFont = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = "Maple Mono";
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
        maple-mono.opentype
      ];
      fonts.fontconfig.defaultFonts = {
        monospace = [ "DejaVu Sans Mono" ];
        sansSerif = [ "DejaVu Sans" ];
      };
    };

  config.flake.modules.hjem.desktop = {
    fuzzel.extraConfig = ''font="${appFont}:size=13"'';
    ghostty.extraConfig = ''
      font-family = ${appFont}
      font-size = 14
    '';
  };

  config.flake.modules.hjem.macbook =
    { pkgs, ... }:
    {
      packages = [ pkgs.maple-mono.opentype ];
    };
}
