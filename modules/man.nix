{ lib, ... }:
{
  flake.modules = {
    homeManager.core.programs.man.generateCaches = lib.mkOverride 500 false;
    homeManager.desktop.programs.man.generateCaches = true;

    nixos.core.documentation.man.generateCaches = lib.mkOverride 500 false;
    nixos.desktop =
      { pkgs, ... }:
      {
        documentation.man.generateCaches = true;
        environment.systemPackages = [ pkgs.man-pages ];
      };
  };
}
