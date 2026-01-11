{
  flake.modules.nixos.desktop =
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
        fantasque-sans-mono
      ];
      fonts.fontconfig.defaultFonts = {
        monospace = [ "DejaVu Sans Mono" ];
        sansSerif = [ "DejaVu Sans" ];
      };
    };
}
