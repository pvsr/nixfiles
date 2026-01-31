{
  flake.modules.nixos.desktop =
    { lib, pkgs, ... }:
    {
      nixpkgs.config.allowUnfreePredicate = pkg: lib.hasPrefix "steam" pkg.pname;
    };
}
