{
  system,
  inputs,
  pkgs,
}:
let
  homeManagerConfiguration =
    module:
    inputs.home-manager-unstable.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        module
        { nix.registry = builtins.mapAttrs (_: flake: { inherit flake; }) inputs; }
      ];
    };
in
{
  valleria = homeManagerConfiguration ./valleria.nix;
  jurai = homeManagerConfiguration ./macbook.nix;
}
