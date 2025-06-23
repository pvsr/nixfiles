{
  self,
  inputs,
  config,
  lib,
  ...
}:
{
  options.local.homeConfigurations = lib.mkOption {
    type = lib.types.attrsOf lib.types.deferredModule;
  };

  config.perSystem =
    { pkgs, ... }:
    {
      legacyPackages.homeConfigurations = builtins.mapAttrs (
        _: module:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            module
            self.modules.homeManager.standalone
          ];
        }
      ) config.local.homeConfigurations;
    };
}
