inputs:
let
  lib = inputs.nixpkgs.lib;
  specialArgs.inputs = inputs;
  overlays = [
    (import ../overlay.nix inputs)
    inputs.niri.overlays.niri
  ];
  baseModules = [
    inputs.agenix.nixosModules.age
    inputs.disko.nixosModules.disko
    ../modules/nix.nix
    ../modules/nixos.nix
    ../users/peter.nix
    {
      nixpkgs.overlays = overlays;
    }
  ];
  unstable = {
    nixpkgs = inputs.unstable;
    home-manager = inputs.home-manager-unstable;
  };
  hosts = {
    grancel = {
      containerId = 1;
      inputs = inputs // unstable;
      module = ./grancel;
      hmModule = ../home-manager/grancel.nix;
    };
    ruan = {
      containerId = 2;
      module = ./ruan;
      hmModule = ../home-manager/ruan.nix;
    };
    crossbell = {
      containerId = 3;
      module = ./crossbell;
      hmModule = ../home-manager/common.nix;
    };
    jurai = {
      containerId = 4;
      module = ./jurai;
      hmModule = ../home-manager/nixos.nix;
    };
  };
  nixosSystem =
    _: host:
    let
      hostInputs = host.inputs or inputs;
      hmModule = {
        imports = [
          hostInputs.home-manager.nixosModules.home-manager
        ];
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.peter = host.hmModule;
        };
      };
    in
    hostInputs.nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      modules = baseModules ++ [
        hmModule
        host.module
      ];
    };
in
{
  nixosConfigurations = lib.mapAttrs nixosSystem hosts;

  nixOnDroidConfigurations.default = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
    pkgs = import inputs.unstable {
      system = "aarch64-linux";
      overlays = [ inputs.nix-on-droid.overlays.default ] ++ overlays;
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
