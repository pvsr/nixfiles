{ inputs, config, ... }:
let
  inherit (inputs.nixpkgs) lib;
  inherit (inputs.self.modules.nixos) container host-container;
in
{
  options.local.containers = lib.mkOption {
    type = lib.types.attrsOf lib.types.deferredModule;
    default = { };
  };

  config.flake.nixosConfigurations =
    (lib.mapAttrs' (
      name: host:
      lib.nameValuePair "${name}.incus" (
        lib.nixosSystem {
          modules = host.modules ++ [ host-container ];
        }
      )
    ) config.local.hosts)
    // (builtins.mapAttrs (
      name: module:
      lib.nixosSystem {
        modules = [
          module
          container
        ];
      }
    ) config.local.containers);
}
