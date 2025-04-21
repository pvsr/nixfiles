{ inputs, withSystem, ... }:
let
  unstable = {
    nixpkgs = inputs.unstable;
    home-manager = inputs.home-manager-unstable;
  };
in
{
  imports = [ ./module.nix ];

  local.flake.hosts = {
    grancel = {
      inputs = inputs // unstable;
      containerId = 1;
      home = ../home-manager/grancel.nix;
    };
    ruan = {
      containerId = 2;
      home = ../home-manager/ruan.nix;
    };
    crossbell = {
      containerId = 3;
      home = ../home-manager/common.nix;
    };
    jurai = {
      system = "aarch64-linux";
      containerId = 4;
      home = ../home-manager/nixos.nix;
    };
  };

  flake.nixOnDroidConfigurations.default = withSystem "aarch64-linux" (
    { system, pkgs, ... }:
    inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import inputs.unstable {
        inherit system;
        overlays = pkgs.overlays ++ [
          inputs.nix-on-droid.overlays.default
        ];
      };
      home-manager-path = inputs.home-manager-unstable.outPath;
      modules = [
        ./arseille
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            config = ../home-manager/arseille.nix;
          };
        }
      ];
    }
  );
}
