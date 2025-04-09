{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      homeManagerConfiguration =
        module:
        inputs.home-manager-unstable.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs.inputs = inputs;
          modules = [
            module
            { nix.registry = builtins.mapAttrs (_: flake: { inherit flake; }) inputs; }
          ];
        };
    in
    {
      legacyPackages.homeConfigurations = {
        valleria = homeManagerConfiguration ./valleria.nix;
        jurai = homeManagerConfiguration ./macbook.nix;
      };
    };
}
