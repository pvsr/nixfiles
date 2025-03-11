system: inputs:
let
  overlays = [
    (import ../overlay.nix inputs)
    inputs.niri.overlays.niri
  ];
  pkgs = import inputs.unstable { inherit system overlays; };
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
