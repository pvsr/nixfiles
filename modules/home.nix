{ inputs, ... }:
{
  flake.modules.nixos.core =
    { config, lib, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      options.local.home.imports = lib.mkOption {
        type = lib.types.listOf lib.types.deferredModule;
        default = [ ];
        apply = modules: [ inputs.self.modules.homeManager.core ] ++ modules;
      };
      config.home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${config.local.user.name} = {
          inherit (config.local.home) imports;
          home.stateVersion = config.system.stateVersion;
        };
      };
    };
}
