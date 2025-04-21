{
  config,
  lib,
  inputs,
  withSystem,
  ...
}:
let
  hosts = config.local.flake.hosts;
  mkHome = homeModule: {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.peter = homeModule;
    };
  };
in
{
  options.local.flake.hosts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, config, ... }:
        {
          options = {
            system = lib.mkOption { default = "x86_64-linux"; };
            containerId = lib.mkOption { type = lib.types.int; };
            inputs = lib.mkOption { default = inputs; };
            home = lib.mkOption {
              type = lib.types.nullOr lib.types.path;
            };
            modules = lib.mkOption {
              readOnly = true;
              default = [
                ./${name}
                ../modules
                { networking.hostName = name; }
                { nixpkgs.overlays = withSystem config.system ({ pkgs, ... }: pkgs.overlays); }
                { local.machines = { inherit hosts; }; }
              ];
            };
          };
        }
      )
    );
  };

  config.flake.nixosConfigurations = builtins.mapAttrs (
    _: host:
    host.inputs.nixpkgs.lib.nixosSystem {
      inherit (host) system;
      specialArgs = { inherit (host) inputs; };
      modules =
        host.modules
        ++ lib.optionals (host.home != null) [
          (mkHome host.home)
          host.inputs.home-manager.nixosModules.home-manager
        ];
    }
  ) hosts;
}
