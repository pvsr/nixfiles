{ inputs, config, ... }:
let
  inherit (inputs.nixpkgs) lib;
  hostOptions = lib.types.submodule (
    { name, config, ... }:
    {
      options.modules = lib.mkOption {
        default = [
          { networking.hostName = name; }
          inputs.self.modules.nixos.core
          inputs.self.modules.nixos.${name}
          { local.home.imports = [ inputs.self.modules.homeManager.${name} or { } ]; }
        ];
      };
      options.nixos = lib.mkOption { default = lib.nixosSystem { inherit (config) modules; }; };
    }
  );
in
{
  options.local.hosts = lib.mkOption { type = lib.types.attrsOf hostOptions; };
  config.flake.nixosConfigurations = builtins.mapAttrs (_: host: host.nixos) config.local.hosts;
}
