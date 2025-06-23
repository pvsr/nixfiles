{ self, inputs, ... }:
{
  flake.modules.nixos.core =
    { config, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.peter.home.stateVersion = config.system.stateVersion;
        users.peter.imports = [ self.modules.homeManager.core ];
      };
    };
}
