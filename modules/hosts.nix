{ lib, inputs, ... }:
{
  options.local.hosts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { config, ... }:
        {
          options = {
            id = lib.mkOption { type = lib.types.int; };
            system = lib.mkOption { default = "x86_64-linux"; };
            inputs = lib.mkOption { default = inputs; };
            home = lib.mkOption { type = lib.types.nullOr lib.types.path; };
            modules = lib.mkOption { type = lib.types.listOf lib.types.deferredModule; };
            nixosConfiguration = lib.mkOption {
              default = config.inputs.nixpkgs.lib.nixosSystem {
                inherit (config) system modules;
                specialArgs = { inherit (config) inputs; };
              };
            };
          };
        }
      )
    );
  };
}
