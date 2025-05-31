{ inputs, withSystem, ... }:
{
  imports = [ ./module.nix ];

  local.hosts = {
    grancel = {
      id = 2;
      home = ../home-manager/grancel.nix;
    };
    ruan = {
      id = 3;
      home = ../home-manager/ruan.nix;
    };
    crossbell = {
      id = 1;
      home = ../home-manager/common.nix;
    };
    jurai = {
      id = 5;
      system = "aarch64-linux";
      home = ../home-manager/nixos.nix;
    };
  };

  flake.nixOnDroidConfigurations.default = withSystem "aarch64-linux" (
    { system, pkgs, ... }:
    inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = pkgs.overlays ++ [
          inputs.nix-on-droid.overlays.default
        ];
      };
      home-manager-path = inputs.home-manager.outPath;
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
