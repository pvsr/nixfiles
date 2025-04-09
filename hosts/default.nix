{ inputs, withSystem, ... }:
let
  lib = inputs.nixpkgs.lib;
  unstable = {
    nixpkgs = inputs.unstable;
    home-manager = inputs.home-manager-unstable;
  };
  mkHome = module: {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.peter = module;
    };
  };
  hosts = {
    grancel = {
      inputs = inputs // unstable;
      system = "x86_64-linux";
      containerId = 1;
      module = ./grancel;
      home = mkHome ../home-manager/grancel.nix;
    };
    ruan = {
      inherit inputs;
      system = "x86_64-linux";
      containerId = 2;
      module = ./ruan;
      home = mkHome ../home-manager/ruan.nix;
    };
    crossbell = {
      inherit inputs;
      system = "x86_64-linux";
      containerId = 3;
      module = ./crossbell;
      home = mkHome ../home-manager/common.nix;
    };
    jurai = {
      inherit inputs;
      system = "aarch64-linux";
      containerId = 4;
      module = ./jurai;
      home = mkHome ../home-manager/nixos.nix;
    };
  };
  mkSystem =
    host:
    withSystem host.system (
      { pkgs, ... }:
      let
        inputs = host.inputs;
        inherit (inputs) nixpkgs home-manager;
        specialArgs = { inherit inputs; };
      in
      nixpkgs.lib.nixosSystem {
        inherit (host) system;
        inherit specialArgs;
        modules = [
          host.module
          host.home
          ../modules
          home-manager.nixosModules.home-manager
          { nixpkgs.overlays = pkgs.overlays; }
          {
            local.machines = {
              inherit specialArgs;
              inherit hosts;
            };
          }
        ];
      }
    );
in
{
  flake.nixosConfigurations = lib.mapAttrs (_: mkSystem) hosts;

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
