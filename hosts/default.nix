inputs:
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
      containerId = 1;
      inputs = inputs // unstable;
      module = ./grancel;
      home = mkHome ../home-manager/grancel.nix;
    };
    ruan = {
      containerId = 2;
      module = ./ruan;
      home = mkHome ../home-manager/ruan.nix;
    };
    crossbell = {
      containerId = 3;
      module = ./crossbell;
      home = mkHome ../home-manager/common.nix;
    };
    jurai = {
      containerId = 4;
      module = ./jurai;
      home = mkHome ../home-manager/nixos.nix;
    };
  };
  mkSystem =
    host:
    let
      inherit (host.inputs or inputs) nixpkgs home-manager;
    in
    nixpkgs.lib.nixosSystem {
      specialArgs = {
        inputs = host.inputs or inputs;
      };
      modules = [
        host.module
        host.home
        ../modules
        home-manager.nixosModules.home-manager
        { local.machines = { inherit hosts; }; }
      ];
    };
in
{
  nixosConfigurations = lib.mapAttrs (_: mkSystem) hosts;

  nixOnDroidConfigurations.default = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
    pkgs = import inputs.unstable {
      system = "aarch64-linux";
      overlays = [
        (import ../overlay.nix inputs)
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
  };
}
