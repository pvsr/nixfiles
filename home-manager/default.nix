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

  flake.modules.homeManager.non-nixos = {
    imports = [ self.modules.homeManager.core ];
    nix.registry = builtins.mapAttrs (_: flake: { inherit flake; }) inputs;
  };

  perSystem =
    { pkgs, ... }:
    let
      homeManagerConfiguration =
        module:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            module
            self.modules.homeManager.non-nixos
          ];
        };
    in
    {
      legacyPackages.homeConfigurations = {
        valleria = homeManagerConfiguration self.modules.homeManager.valleria;
        jurai = homeManagerConfiguration self.modules.homeManager.macbook;
      };
    };
}
