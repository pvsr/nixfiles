{ lib, ... }:
{
  flake.modules.nixos = {
    core.documentation.man.cache.enable = lib.mkOverride 500 false;
    desktop =
      { pkgs, ... }:
      {
        documentation.enable = true;
        documentation.doc.enable = true;
        documentation.nixos.enable = true;

        documentation.man.enable = true;
        documentation.man.cache.enable = true;
        environment.systemPackages = [ pkgs.man-pages ];
      };
    test = {
      documentation.enable = lib.mkForce false;
      documentation.nixos.enable = lib.mkForce false;
    };
  };
}
