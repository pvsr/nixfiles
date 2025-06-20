{
  self,
  inputs,
  config,
  lib,
  withSystem,
  ...
}:
{
  options.local.hosts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options.system = lib.mkOption { default = "x86_64-linux"; };
      }
    );
  };

  config.flake.modules.nixos = builtins.mapAttrs (name: config: {
    imports = [ self.modules.nixos.core ];
    networking.hostName = name;
    nixpkgs.system = config.system;
    nixpkgs.overlays = withSystem config.system ({ pkgs, ... }: pkgs.overlays);
    home-manager.users.peter.imports = [
      (self.modules.homeManager.${name} or { })
    ];
  }) config.local.hosts;

  config.flake.nixosConfigurations = builtins.mapAttrs (
    name: _: inputs.nixpkgs.lib.nixosSystem { modules = [ self.modules.nixos.${name} ]; }
  ) config.local.hosts;
}
