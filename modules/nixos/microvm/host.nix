{
  self,
  inputs,
  lib,
  config,
  ...
}:
let
  allVms = config.local.vms;
in
{
  options.local.vms = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          host = lib.mkOption { type = lib.types.str; };
          module = lib.mkOption {
            type = lib.types.deferredModule;
            default = { };
          };
        };
      }
    );
    default = { };
  };

  config.flake.nixosConfigurations = builtins.mapAttrs (
    name: vm:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        vm.module
        inputs.microvm.nixosModules.microvm
        inputs.self.modules.nixos.base
        inputs.self.modules.nixos.microvm-guest
        {
          networking.hostName = name;
          networking.domain = self.nixosConfigurations.${vm.host}.config.networking.fqdn;
        }
      ];
    }
  ) allVms;

  config.flake.modules.nixos.core =
    { config, pkgs, ... }:
    let
      vms = lib.filterAttrs (_: vm: vm.host == config.networking.hostName) allVms;
      enable = vms != { };
    in
    {
      imports = [ inputs.microvm.nixosModules.host ];

      config.environment.persistence.nixos = lib.mkIf enable { directories = [ config.microvm.stateDir ]; };

      config.microvm = {
        host.enable = lib.mkDefault enable;
        host.useNotifySockets = true;
        host.installCommand = false;
        vms = builtins.mapAttrs (_: _: {
          flake = self;
          updateFlake = "git+file:///etc/nixos";
        }) vms;
      };

      config.environment.systemPackages = lib.mkIf config.microvm.host.enable [
        (pkgs.callPackage "${inputs.microvm}/pkgs/microvm-command.nix" {
          nix = config.nix.package;
          inherit (config.microvm) stateDir;
        })
      ];
    };
}
