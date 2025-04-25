{
  config,
  lib,
  inputs,
  withSystem,
  ...
}:
let
  hosts = config.local.flake.hosts;
  mkHome =
    homeModule:
    { inputs, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
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
            id = lib.mkOption { type = lib.types.int; };
            system = lib.mkOption { default = "x86_64-linux"; };
            inputs = lib.mkOption { default = inputs; };
            home = lib.mkOption { type = lib.types.nullOr lib.types.path; };
            modules = lib.mkOption {
              readOnly = true;
              default = [
                ./${name}
                ../modules
                { networking.hostName = name; }
                { nixpkgs.overlays = withSystem config.system ({ pkgs, ... }: pkgs.overlays); }
                { local.machines = { inherit hosts; }; }
              ] ++ lib.optional (config.home != null) (mkHome config.home);
            };
          };
        }
      )
    );
  };

  config.flake.nixosConfigurations = builtins.mapAttrs (
    _: host:
    host.inputs.nixpkgs.lib.nixosSystem {
      inherit (host) system modules;
      specialArgs = { inherit (host) inputs; };
    }
  ) hosts;
}
