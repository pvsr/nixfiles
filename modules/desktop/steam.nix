{ lib, ... }:
{
  flake.modules.nixos.desktop =
    { config, pkgs, ... }:
    {
      nixpkgs.config = lib.mkIf config.programs.steam.enable {
        allowUnfreePredicate = pkg: lib.hasPrefix "steam" pkg.pname;
      };
    };

  flake.modules.nixos.test.programs.steam.enable = lib.mkForce false;
}
